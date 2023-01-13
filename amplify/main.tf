resource "aws_amplify_app" "main" {
  name                     = var.app-name
  repository               = var.repository
  access_token             = var.access-token
  enable_branch_auto_build = true
  build_spec               = <<-EOT
    version: 0.3
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
  platform = "WEB_COMPUTE"
  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }
  environment_variables = {
    ENV = "dev"
  }
}

resource "aws_amplify_branch" "dev" {
  app_id      = aws_amplify_app.main.id
  branch_name = "dev"
  framework   = "Next.js - SSR"
  stage       = "DEVELOPMENT"
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = "main"
  framework   = "Next.js - SSR"
  stage       = "PRODUCTION"
}