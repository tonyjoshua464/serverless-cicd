provider "aws" {
  region = "us-east-1"
}
resource "aws_dynamodb_table" "test_table" {
  name         = "TestTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
resource "aws_ecs_cluster" "serverless_cluster" {
  name = "serverless-cluster"
}
resource "aws_ecs_task_definition" "serverless_task" {
  family                   = "serverless-task"
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions    = <<EOF
[
  {
    "name": "serverless-app",
    "image": "651706755187.dkr.ecr.us-east-1.amazonaws.com/serverless:latest",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
EOF
}
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}
