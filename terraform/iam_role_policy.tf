#######################
# ecs_service_policy
#######################
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "bischierge_ecs_service_role_policy"
  policy = data.aws_iam_policy_document.bischierge_ecs_service_policy.json
  role   = aws_iam_role.bischierge_ecs_role.id
}

data "aws_iam_policy_document" "bischierge_ecs_service_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]
  }
}

#######################
# ecs_execution_policy
#######################
resource "aws_iam_role_policy" "bischierge_ecs_execution_role_policy" {
  name   = "bischierge_ecs_execution_role_policy"
  policy = data.aws_iam_policy_document.bischierge_ecs_execution_policy.json
  role   = aws_iam_role.bischierge_ecs_execution_role.id
}

data "aws_iam_policy_document" "bischierge_ecs_execution_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ecr:*",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}
