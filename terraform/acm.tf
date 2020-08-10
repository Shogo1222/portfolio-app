#######################
# bischierge.work
#######################
resource "aws_acm_certificate" "bischierge-certificate" {
  domain_name = "bischierge.work"
  subject_alternative_names = ["www.${aws_route53_zone.bischierge-work.name}"]
  validation_method = "DNS"
  tags = {
    "bischierge" = "certificate"
  }
}

# add validation record to Route53 Host zone
resource "aws_route53_record" "bischierge-work-cert-valid" {
  zone_id = aws_route53_zone.bischierge-work.zone_id
  for_each = {
  for dvo in aws_acm_certificate.bischierge-certificate.domain_validation_options: dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
}
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}

#######################
# bisapi.work
#######################
resource "aws_acm_certificate" "bisapi-certificate" {
  domain_name = aws_route53_zone.bisapi-work.name
  subject_alternative_names = ["www.${aws_route53_zone.bisapi-work.name}"]
  validation_method = "DNS"
  tags = {
    "bisapi" = "certificate"
  }
}

# add validation record to Route53 Host zone
resource "aws_route53_record" "biapi-work-cert-valid" {
  zone_id = aws_route53_zone.bisapi-work.zone_id

  for_each = {
  for dvo in aws_acm_certificate.bisapi-certificate.domain_validation_options: dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
}
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}
