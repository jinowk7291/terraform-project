# S3 Endpoint
resource "aws_vpc_endpoint" "test" {
  vpc_id  = "aws_vpc.test.id"
  service_name = "com.amazonaws.ap-northeast-2.s3"
}

resource "aws_s3_bucket" "tests3" {
  bucket = "cass-terraform-bucket"
  acl    = "private"

  versioning {
      enabled = true
  }

  lifecycle_rule {
    prefix = "image/"
    enabled = true

    noncurrent_version_expiration {
      days = 180
    }
  }

  tags = {
    "Name" = "terracass-s3.tf"
  }
}


resource "aws_cloudwatch_metric_alarm" "cloudwatch" {
  alarm_name                = "terraform-test-cloudwatch"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/S3"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  #threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.node.resources[0]["autoscaling_groups"][0]["name"]
  }


} 
