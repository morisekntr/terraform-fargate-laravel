output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "ecs_service_arn" {
  value = aws_ecs_service.main.id
}