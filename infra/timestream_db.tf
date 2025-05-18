resource "aws_timestreamwrite_database" "iot_db" {
  database_name = "IoTDB"
}

resource "aws_timestreamwrite_table" "iot_table" {
  database_name = aws_timestreamwrite_database.iot_db.database_name
  table_name    = "SensorData"

  retention_properties {
    memory_store_retention_period_in_hours  = 3 # Data kept in memory
    magnetic_store_retention_period_in_days = 7 # Data kept in magnetic storage
  }
}
