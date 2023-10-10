resource "aws_scheduler_schedule" "start" {
  name = "EKS-Nodegroup-Scheduler-START"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(00 9 ? * 2-6 *)"
  schedule_expression_timezone = "Asia/Calcutta"

  target {
    arn      = "${aws_lambda_function.EKS-Start.arn}"
    role_arn = aws_iam_role.eks-start-stop.arn
  }
  depends_on = [ aws_lambda_function.EKS-Start ]
}

resource "aws_scheduler_schedule" "stop" {
  name = "EKS-Nodegroup-Scheduler-STOP"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(00 21 ? * 2-6 *)"
  schedule_expression_timezone = "Asia/Calcutta"


  target {
    arn      = "${aws_lambda_function.EKS-Stop.arn}"
    role_arn = aws_iam_role.eks-start-stop.arn
  }
  depends_on = [ aws_lambda_function.EKS-Stop ]
}
