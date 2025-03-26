variable "db_username" {
  description = "PostgreSQL server administrator username"
  type        = string
  sensitive   = true
}


variable "db_password" {
  description = "PostgreSQL server administrator password"
  type        = string
  sensitive   = true
}
