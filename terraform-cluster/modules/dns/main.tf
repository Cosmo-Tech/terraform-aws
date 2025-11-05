data "aws_route53_zone" "zone" {
  name = var.domain_name
}


# Load balancer is created from NGinx ingress Helm Chart
data "aws_lb" "load_balancer" {
  tags = {
    "eks:eks-cluster-name" = var.main_name
  }
}


resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.main_name
  type = "CNAME"
  ttl  = "3600"
  records = [
    data.aws_lb.load_balancer.dns_name
  ]
}
