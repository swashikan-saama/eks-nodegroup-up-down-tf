data "aws_region" "current" {}

resource "aws_lambda_function" "EKS-Stop" {
  function_name = "EKS-Nodegroup-Scheduler-STOP"
  description = "Triggers the Nodegroups sizes to thier own tags and make Nodegroups to become 0 sizes"
  handler      = "EKS-Nodegroup-Scheduler-STOP.lambda_handler"
  runtime      = "python3.11"
  timeout      = 900
  role = aws_iam_role.eks-start-stop.arn
  architectures = [ "arm64" ]
  filename = "scripts/EKS-Nodegroup-Scheduler-STOP.zip" 
  environment {
    variables = {
      KEY = "EKS-AutoStop",
      REGION = "${data.aws_region.current.name}",
      VALUE = "Yes"
    }
  }
}

resource "aws_lambda_function" "EKS-Start" {
  function_name = "EKS-Nodegroup-Scheduler-START"
  description = "Triggers the Nodegroups sizes back to thier own Sizes from Nodegroups Tags"
  handler      = "EKS-Nodegroup-Scheduler-START.lambda_handler"
  runtime      = "python3.11"
  timeout      = 900
  role = aws_iam_role.eks-start-stop.arn
  architectures = [ "arm64" ]
  filename = "scripts/EKS-Nodegroup-Scheduler-START.zip" 
  environment {
    variables = {
      KEY = "EKS-AutoStart",
      REGION = "${data.aws_region.current.name}",
      VALUE = "Yes"
    }
  }
}
