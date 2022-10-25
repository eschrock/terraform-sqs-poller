resource "aws_sqs_queue" "schedule" {
  name = "${var.prefix}-schedule"
}

resource "aws_sqs_queue" "monitor" {
  name = "${var.prefix}-monitor"
  delay_seconds = var.monitor_delay
}

resource "aws_sqs_queue" "complete" {
  name = "${var.prefix}-complete"
}

resource "aws_lambda_event_source_mapping" "schedule" {
  batch_size        = 1
  event_source_arn  = aws_sqs_queue.schedule.arn
  enabled           = true
  function_name     = var.schedule_lambda_arn
}

resource "aws_lambda_event_source_mapping" "monitor" {
  batch_size        = 1
  event_source_arn  = aws_sqs_queue.monitor.arn
  enabled           = true
  function_name     = var.monitor_lambda_arn
}

resource "aws_iam_policy" "read" {
  name              = "${var.prefix}-read"
  description       = "Read messages from the polling queues"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ReadMlQueues",
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_sqs_queue.schedule.arn}",
        "${aws_sqs_queue.monitor.arn}",
        "${aws_sqs_queue.complete.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "write" {
  name              = "${var.prefix}-write"
  description       = "Write messages to the polling queues"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "WriteMlQueues",
      "Action": [
        "sqs:SendMessage"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_sqs_queue.schedule.arn}",
        "${aws_sqs_queue.monitor.arn}",
        "${aws_sqs_queue.complete.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_event_source_mapping" "complete" {
  batch_size        = 1
  event_source_arn  = aws_sqs_queue.complete.arn
  enabled           = true
  function_name     = var.complete_lambda_arn
}