
#######################
# bischierge.work
#######################
resource "aws_route53_zone" "bischierge-work" {
  name    = "bischierge.work"
  comment = "domain for front"

  tags = {
    Name = "bischierge.work"
  }
}

resource "aws_route53_record" "bischierge-work-host-zone-record" {
  zone_id = aws_route53_zone.bischierge-work.zone_id
  name    = "www.bischierge.work"
  type    = "A"

  alias {
    name                   = aws_lb.bischierge-front-alb.dns_name
    zone_id                = aws_lb.bischierge-front-alb.zone_id
    evaluate_target_health = false
  }
}


#######################
# bisapi.work
#######################
resource "aws_route53_zone" "bisapi-work" {
  name    = "bisapi.work"
  comment = "domain for rails"

  tags = {
    Name = "bisapi.work"
  }
}

resource "aws_route53_record" "bisapi-work-host-zone-record" {
  zone_id = aws_route53_zone.bisapi-work.zone_id
  name    = "www.bisapi.work"
  type    = "A"

  alias {
    name                   = aws_lb.bischierge-back-alb.dns_name
    zone_id                = aws_lb.bischierge-back-alb.zone_id
    evaluate_target_health = false
  }
}
