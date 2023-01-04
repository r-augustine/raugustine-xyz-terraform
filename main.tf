module "amplify" {
  source       = "./amplify"
  app-name     = "raugustine-xyz"
  repository   = "https://github.com/r-augustine/raugustine-xyz"
  access-token = var.access-token
}