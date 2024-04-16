resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "test1"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  #TODO: Remove task definition name from here
  family             = "my-ecs-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::344974554678:role/ecsTaskExecutionRole"
  cpu                = "512"
  memory             = "1024"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = "#${module.railswave_repository.repository_url}:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment : [
        {
          name  = "RAILS_ENV"
          value = var.RAILS_ENV
        },
        {
          name  = "SECRET_KEY_BASE"
          value = var.SECRET_KEY_BASE
        },
        {
          name  = "RAILS_DATABASE_NAME"
          value = var.RAILS_DATABASE_NAME
        },
        {
          name  = "RAILS_DATABASE_HOST"
          value = var.RAILS_DATABASE_HOST
        },
        {
          name  = "RAILS_DATABASE_USER"
          value = var.RAILS_DATABASE_USERNAME
        },
        {
          name  = "RAIL_DATABASE_PASSWORD"
          value = var.RAILS_DATABASE_PASSWORD
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.security_group.id]
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "dockergs"
    container_port   = 3000
  }

  depends_on = [aws_autoscaling_group.ecs_asg]
}
