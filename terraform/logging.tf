
resource "aws_cloudwatch_log_group" "exec" {
  name = "/aws/ecs/sayless-exec-logs"
}

resource "aws_cloudwatch_log_group" "sayless" {
  name              = "/ecs/app"
  retention_in_days = 30

  tags = {
    Name = "sayless-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "sayless" {
  name           = "sayless-log-stream"
  log_group_name = aws_cloudwatch_log_group.sayless.name
}
