resource "aws_iam_role" "eks-start-stop" {
  name = "EKS-Nodegroup-Scheduler"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "scheduler.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }

    ]
})
}


resource "aws_iam_role_policy" "eks-start-stop-policy" {
  name = "EKS-Nodegroup-Scheduler-policy"
  role = aws_iam_role.eks-start-stop.id
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"logs:CreateLogStream",
				"logs:CreateLogGroup",
                "logs:PutLogEvents",
                "eks:*",
			],
			"Resource": "*"
		},
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": [
                "${aws_lambda_function.EKS-Start.arn}:*",
                "${aws_lambda_function.EKS-Start.arn}",
                "${aws_lambda_function.EKS-Stop.arn}:*",
                "${aws_lambda_function.EKS-Stop.arn}"
            ]
        }
	]
})
  depends_on = [ aws_lambda_function.EKS-Start,aws_lambda_function.EKS-Stop ]
}
