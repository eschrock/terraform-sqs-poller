output "sqs_schedule_id" {
  value = aws_sqs_queue.schedule.id
}

output "sqs_monitor_id" {
  value = aws_sqs_queue.monitor.id
}

output "sqs_complete_id" {
  value = aws_sqs_queue.complete.id
}

output "iam_policy_read_arn" {
  value = aws_iam_policy.read.arn
}

output "iam_policy_write_arn" {
  value = aws_iam_policy.write.arn
}