variable "thing" {
  description = "Name of the thing"
  default     = "esp32-dht11"
}

variable "thing_policy" {
  description = "Name of the Policy to apply to certificate."
  default     = "esp32_policy"
}

variable "topic" {
  description = "Name of the topic in the path for MQTT."
  default     = ""
}

