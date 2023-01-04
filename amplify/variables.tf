variable "app-name" {
  type = string
  description = "Application name"
}

variable "repository" {
    type = string 
    description = "Git repository url"
}

variable "role-arn" {
    type = string
    description = "IAM service role arn"
}

variable "access-token" {
    type = string
    description = "GitHub access token"
}
