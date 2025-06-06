disable_mlock = true

storage "file" {
  path = "/vault/file"
}


listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

ui = true
log_level = "debug"