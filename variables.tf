# variable "user_uuid" {
#   type        = string
#   description = "User UUID of the user"

#   validation {
#     condition     = can(regex("^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$", var.user_uuid))
#     error_message = "User UUID must be in the format of a UUID (e.g., 01234567-89ab-cdef-0123-456789abcdef)"

#   }
# }