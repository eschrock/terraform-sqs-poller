# Terraform SQS poller

This is a really simple module for creating a polling framework using lambdas and
AWS SQS. This is useful when, for example, there is an external API that you want
to monitor without having to have an active thread running for the duration of
the call.

The module creates three queues: `schedule`, `monitor`, and `complete`. New messages
are posted to the schedule queue, and the handler then makes a request to an external
service, posting a subsequent message to the monitor queue. The monitor handler
will check the status, and either put a message back on the monitor queue to check
again later, or put a message on the complete queue. Messages are then pulled off the
complete queue for final processing (success or failure). The monitoring queue has
a built in delay (configurable but defaulting to 1 second).


## Inputs

 * `prefix` - Naming prefix for objects. Everything is named `{prefix}-name`.
 * `schedule_lambda_arn` - Required. Lambda to invoke when a message is ready to
   be processed from the schedule queue. This lambda should perform any required
   action and then post messages to the monitor queue or completion queue (in
   the event of failuer).
 * `monitor_lambda_arn` - Required. Lambda to invoke when a message is ready to
   be processed by the monitoring queue. This lambda should query current remote
   state and either post the message back to the monitor queue (keep polling) or
   complete queue (success or failure).
 * `complete_lambda_arn` - Required. Lambda to invoke when a message is ready to
   by processed from the complete queue. This lamdbda should persist any completed
   state or otherwise notify any consumers.
 * `monitor_delay` - Optional. Delay, in seconds, between monitoring processing.
   Defaults to 1 second.

## Outputs

 * `sqs_schedule_id` - ID of the schedule queue
 * `sqs_monitor_id` - ID of the monitor queue
 * `sqs_complete_id` - ID of the complete queue
 * `iam_policy_read_arn` - ARN of the IAM policy to read from queues
 * `iam_policy_write_arn` - ARN of the IAM policy to write to queues

For simplicity, there is a single read and write policy for all queues. Lambdas should
have appropriate read and write policies applied.