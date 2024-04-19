resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/app"
  retention_in_days = 1
}
