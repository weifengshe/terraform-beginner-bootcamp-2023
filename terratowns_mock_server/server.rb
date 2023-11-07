require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

# We will mock having a state or database for the development server
# by setting a global variable. You would never use a global variable 
# in production server. 
$home = {}

# This is a ruby class that includes validations from Active Record.
# This will represent our Home resources as a ruby objects. 
class Home
  # ActiveModel is part of Ruby on Rails
  # It is used as ORM. It has a module within 
  # ActiveModule that provides validation. 
  # The production Terratowns server is rails and uses 
  # very similar and in most cases identical validation 
  # https://guides.rubyonrails.org/active_model_basics.html
  # https://guides.rubyonrails.org/active_record_validations.html 
  include ActiveModel::Validations

  # Create some virtual attributes to stored on this object 
  # This will set a getter and setter
  # Eg.
  # home = Home()
  # home.town = 'hello' # setter
  # home.town() # getter
  attr_accessor :town, :name, :description, :domain_name, :content_version

  validates :town, presence: true, inclusion: { in: [
    # terratowns.cloud
    'melomaniac-mansion',
    'cooker-cove',
    'video-valley',
    'the-nomad-pad',
    'gamers-grotto'
  ]}

  # visible to all users 
  validates :name, presence: true
  #  visible to all users
  validates :description, presence: true
  # We want to lock this down to only be from cloudfront 
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 

  # content version must be an integer
  # We will make sure it an incremental version in the controller. 
  validates :content_version, numericality: { only_integer: true }
end

# We are extendinng a class from Sinatra::Base to 
# turn this generic class to utilize the sinatra web-framework 
class TerraTownsMockServer < Sinatra::Base


  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end

  # return a hardcoded access token 
  def x_access_code
    '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    # https://swagger.io/docs/specification/authentication/bearer-authentication/
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # check if the Authorization header exists? 
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # Does the token match the one in our database? 
    # if we can't find it, then return an error of it it doesn't match
    # code = access_code_token 
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # Was there a user_uuid in the body payload json? 
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # the code and the user_uuid should be matching for user
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    # in ruby "()" in function is optional, next 2 are functions 
    ensure_correct_headings()
    find_user_by_bearer_token()
    # Puts will print to the terminal, similar to a print or console.log
    puts "# create - POST /api/homes"

    # a begin/rescue is a try/catch, if an error occurs, result it
    begin
      # Siantra does not automatically parse json bodys as params
      # like rails, we need to manually parse it
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Assign the payload to varialbe
    # to make easier to work with the code
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]

    # printting the variables out to console to make it easier
    # to see or debug what we have inputed into this endpoint
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"


    # Create a new Home model and set to attributes 
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    # Ensure our validation checks pass otherwise
    # return the errors 
    unless home.valid?
      # Return the errors message back json 
      error 422, home.errors.messages.to_json
    end

    # Generate a uuid at random
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    # Will mock our data to our mock database
    # Which just a global variable
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }
    # will just return uuid 
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  # Very similar to create action
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.domain_name = $home[:domain_name]
    home.name = name
    home.description = description 
    home.content_version = content_version
    binding.pry

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    # Delete from mock database
    uuid = $home[:uuid]
    $home = {}
    { uuid: uuid }.to_json
    #  { message: "House deleted successfully" }.to_json
  end
end

# This is whatt will run the server. 
TerraTownsMockServer.run!