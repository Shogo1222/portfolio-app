variable "front_image" {}
variable "back_image" {}
variable "rails_master_key" {}

#######################
# CloudWatch Log Group
#######################
resource "aws_cloudwatch_log_group" "bischierge-cloudwatch" {
  name = "bischierge-cloudwatch"

  tags = {
    Application = "bischierge-ecs"
  }
}

#######################
# Cluster
#######################
resource "aws_ecs_cluster" "bischierge-cluster" {
  name = "bischierge-cluster"
}

#######################
# Task Definitions
#######################
data "template_file" "bischierge_front_container" {
  template = file("./task_definitions/bischierge_front_definition.json")

  vars = {
    front_image      = var.front_image
    log_group       = aws_cloudwatch_log_group.bischierge-cloudwatch.name
  }
}

data "template_file" "bischierge_back_container" {
  template = file("./task_definitions/bischierge_back_definition.json")

  vars = {
    back_image      = var.back_image
    rails_master_key = var.rails_master_key
    log_group       = aws_cloudwatch_log_group.bischierge-cloudwatch.name
  }
}

# create Task Definition for front
resource "aws_ecs_task_definition" "bischierge-front-task" {
  family                   = "bischierge-front-task"
  container_definitions    = data.template_file.bischierge_front_container.rendered
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "700"
  execution_role_arn       = aws_iam_role.bischierge_ecs_execution_role.arn
  task_role_arn            = aws_iam_role.bischierge_ecs_execution_role.arn
}

data "aws_ecs_task_definition" "bischierge-front-task" {
  depends_on = [aws_ecs_task_definition.bischierge-front-task]
  task_definition = aws_ecs_task_definition.bischierge-front-task.family
}

# create Task Definition for back
resource "aws_ecs_task_definition" "bischierge-back-task" {
  family                   = "bischierge-back-task"
  container_definitions    = data.template_file.bischierge_back_container.rendered
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "128"
  memory                   = "400"
  execution_role_arn       = aws_iam_role.bischierge_ecs_execution_role.arn
  task_role_arn            = aws_iam_role.bischierge_ecs_execution_role.arn
}

data "aws_ecs_task_definition" "bischierge-back-task" {
  depends_on = [aws_ecs_task_definition.bischierge-back-task]
  task_definition = aws_ecs_task_definition.bischierge-back-task.family
}

#######################
# ECS Service
#######################
resource "aws_ecs_service" "front-ecs-service" {
  name            = "front-ecs-service"
  task_definition = "${aws_ecs_task_definition.bischierge-front-task.family}:${max("${aws_ecs_task_definition.bischierge-front-task.revision}", "${data.aws_ecs_task_definition.bischierge-front-task.revision}")}"
  desired_count   = 1
  launch_type     = "EC2"
  cluster         = aws_ecs_cluster.bischierge-cluster.id
  depends_on      = [
    aws_iam_role_policy.ecs_service_role_policy,
    aws_lb_target_group.bischierge-front-target-group
  ]
  load_balancer {
    target_group_arn = aws_lb_target_group.bischierge-front-target-group.arn
    container_name   = "front"
    container_port   = "3000"
  }
}

resource "aws_ecs_service" "back-ecs-service" {
  name            = "back-ecs-service"
  task_definition = "${aws_ecs_task_definition.bischierge-back-task.family}:${max("${aws_ecs_task_definition.bischierge-back-task.revision}", "${data.aws_ecs_task_definition.bischierge-back-task.revision}")}"
  desired_count   = 1
  launch_type     = "EC2"
  cluster         = aws_ecs_cluster.bischierge-cluster.id
  depends_on      = [
    aws_iam_role_policy.ecs_service_role_policy,
    aws_lb_target_group.bischierge-back-target-group
  ]
  network_configuration {
    security_groups = [
      aws_security_group.bischierge-back-security-group.id
    ]
    subnets         = [
      aws_subnet.subnet-bischierge-back-subnet-1a.id,
      aws_subnet.subnet-bischierge-back-subnet-1c.id
    ]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.bischierge-back-target-group.arn
    container_name   = "back"
    container_port   = "3000"
  }
}
