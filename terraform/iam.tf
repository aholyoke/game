data "aws_kms_key" "key" {
  key_id = "326d8675-528a-4adb-b4bc-d6f7875a892d"
}

resource "aws_iam_role" "task-role" {
  name = "ecs-exec-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "exec-policy" {
  name = "exec-policy"
  role = aws_iam_role.task-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:DescribeLogGroups",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:ca-central-1:448047001996:log-group:/aws/ecs/sayless-exec-logs:*"
      },
      {
        Action = [
          "s3:PutObject",
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::sayless/*"
      },
      {
        Action = [
          "s3:GetEncryptionConfiguration",
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::sayless"
      },
      {
        Action = [
          "kms:Decrypt",
        ]
        Effect = "Allow"
        Resource = "arn:aws:kms:ca-central-1:448047001996:key/326d8675-528a-4adb-b4bc-d6f7875a892d"
      },
    ]
  })
}
