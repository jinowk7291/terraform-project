resource "aws_autoscaling_policy" "bat" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_eks_node_group.node.resources[0]["autoscaling_groups"][0]["name"]


}


resource "aws_cloudwatch_metric_alarm" "cloudwatch" {
  alarm_name                = "terraform-test-cloudwatch"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  #threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.node.resources[0]["autoscaling_groups"][0]["name"]
  }

  alarm_actions     = [aws_autoscaling_policy.bat.arn]

} 

