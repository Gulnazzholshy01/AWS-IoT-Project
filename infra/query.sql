-- IoT CORE queries
SELECT * FROM "IoTDB"."SensorData" WHERE time between ago(15m) and now() ORDER BY time DESC LIMIT 10 
SELECT * FROM "IoTDB"."SensorData"

-- AWS GRAFANA queries
select time, measure_value::bigint from $__database.$__table where measure_name like 'humidity'
select time, measure_value::double from $__database.$__table where measure_name like 'temperature'