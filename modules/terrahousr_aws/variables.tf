variable "user_uuid" {
  type        = string
  description = "User UUID of the user"

  validation {
    condition     = can(regex("^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$", var.user_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., 01234567-89ab-cdef-0123-456789abcdef)"

  }
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 bucket name"
  validation {
    condition     = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "The bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and can contain only lowercase letters, numbers, hyphens, and dots."
  }
}

variable "index_html_filepath" {
  type        = string
  description = "Filepath to the index.html file"
  validation {
    condition     = can(fileexists(var.index_html_filepath))
    error_message = "The provided path for index.html does not exist."
  }
}

variable "error_html_filepath" {
  type        = string
  description = "Filepath to the error.html file"
  validation {
    condition     = can(fileexists(var.error_html_filepath))
    error_message = "The provided path for error.html does not exist."
  }
}

variable "content_version" {
  type        = number
  description = "Content version (positive integer starting from 1)"
  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "Content version must be a positive integer starting from 1."
  }
}

variable "asset_path" {
  description = "Path to assets folder"
  type = string 
}

