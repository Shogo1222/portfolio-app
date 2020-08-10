#######################
# Front Repository
#######################
resource "aws_ecr_repository" "bischierge-front" {
  name                 = "bischierge-front"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#######################
# Back Repository
#######################
resource "aws_ecr_repository" "bischierge-back" {
  name                 = "bischierge-back"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
