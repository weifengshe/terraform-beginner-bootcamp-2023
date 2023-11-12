# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler 

Bundler is a package manager for ruby.
It is the primary way to install ruby packages (Known as gems) for ruby. 

### Install Gems

You need to create a Gemfile and define your gems in that file. 

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run  the `bundle install` command 

This will install the gems on the system golbally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

### Executing Ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context. 

### Sinatra 

Sinatra is a micro  web-framework for ruby to build web-apps. 

Its great for mock or development servers or for every simple projects. 

You can create a web-server in a single file. 

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server

we can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

### Create, Read and Update the new home

Once the server is up running, then in the working directory, run the following commands

```
# Create
./bin/terratownns/create

./bin/terratownns/read <uuid>
./bin/terratownns/update <uuid>
./bin/terratownns/destroy <uuid>
``` 

All of the code for our server is stored in the `server.rb` file.


## CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for Create, Read, Update, Deletet

https://en.wikipedia.org/wiki/Create,_read,_update_and_delete





