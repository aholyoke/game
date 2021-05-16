
resource "aws_ecs_cluster" "sayless" {
  name = "sayless-cluster"
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "sayless" {
  family = "sayless-task-definition"
  network_mode = "awsvpc"

  execution_role_arn = "arn:aws:iam::448047001996:role/ecsTaskExecutionRole"
  task_role_arn      = aws_iam_role.task-role.arn
  
  memory = 512
  cpu    = 256

  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "sayless_container_definition"
      image     = "448047001996.dkr.ecr.ca-central-1.amazonaws.com/game:latest"
      command = ["/home/sayless/.local/bin/uwsgi", "/home/sayless/src/uwsgi.ini"]
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "sayless" {
  name            = "sayless-service"
  cluster         = aws_ecs_cluster.sayless.id
  task_definition = aws_ecs_task_definition.sayless.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  enable_execute_command = true

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "sayless_container_definition"
    container_port   = var.app_port
  }
  depends_on = [aws_alb_listener.front_end]
}
