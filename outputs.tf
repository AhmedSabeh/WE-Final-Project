output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "rds_endpoint" {
  description = "Endpoint of the Aurora cluster"
  value       = aws_rds_cluster.aurora.endpoint
}
