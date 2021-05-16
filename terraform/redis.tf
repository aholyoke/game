resource "aws_elasticache_subnet_group" "sayless" {
  name       = "cache-subnet"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_elasticache_cluster" "sayless" {
  cluster_id           = "sayless-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.0.5"
  port                 = 6379
  security_group_ids = [aws_security_group.cache.id]
  subnet_group_name = aws_elasticache_subnet_group.sayless.name
}