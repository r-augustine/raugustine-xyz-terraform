data "aws_iam_policy" "amplify_policy" {
  name = "AdministratorAccess-Amplify"
}

resource "aws_iam_role" "amplify_role" {
  name = "amplify_deploy_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "amplify.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = var.app-name
  }
}

resource "aws_iam_role_policy_attachment" "amplify_role_attached" {
  role = aws_iam_role.amplify_role.name
  policy_arn = data.aws_iam_policy.amplify_policy.arn
}

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
  iam_service_role_arn = aws_iam_role.amplify_role.arn
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