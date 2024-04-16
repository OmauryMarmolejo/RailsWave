module "railswave_repository" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.0"

  repository_name = "railswave-repo"

  repository_image_tag_mutability = "IMMUTABLE"
  create_lifecycle_policy         = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images by count"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
