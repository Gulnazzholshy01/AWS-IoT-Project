# locals {
#   timestream_table_arn = "arn:aws:timestream:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${aws_timestreamwrite_database.iot_db.database_name}/table/${aws_timestreamwrite_table.iot_table.table_name}"
# }
