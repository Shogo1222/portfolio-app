#######################
# bischierge_ecs_role
#######################
resource "aws_iam_role" "bischierge_ecs_role" {
  name               = "bischierge_ecs_role"
  assume_role_policy = data.aws_iam_policy_document.bischierge_ecs_service_role.json
}

#######################
# bischierge_ecs_execution_role
#######################
resource "aws_iam_role" "bischierge_ecs_execution_role" {
  name               = "bischierge_ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.bischierge_ecs_execution_service_role.json
}

data "aws_iam_policy_document" "bischierge_ecs_service_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bischierge_ecs_execution_service_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
