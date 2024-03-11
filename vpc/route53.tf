# creating route 53 record

# get information of the hosted zone details
data "aws_route53_zone" "hosted_zone" {
  name = "fodek.homes"
}

# creating a record set in route 53
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "www.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"
#   ttl     = 300
#   records = [aws_eip.lb.public_ip]
  alias {
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}