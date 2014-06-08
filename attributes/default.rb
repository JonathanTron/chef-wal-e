include_attribute "python::default"

default["wal-e"]["version"] = "0.7.1"

default["wal-e"]["install_path"] = "/opt/wal-e/"
default["wal-e"]["env_d_path"] = "/etc/wal-e.d/"
default["wal-e"]["env_path"] = ::File.join default["wal-e"]["env_d_path"], "env"
default["wal-e"]["exe_path"] = "/opt/wal-e/bin/wal-e"
default["wal-e"]["exe_with_env"] = "envdir #{default["wal-e"]["env_path"]} #{default["wal-e"]["exe_path"]}"

default["wal-e"]["s3"]["data_bag"] = "aws_credentials"
default["wal-e"]["s3"]["data_bag_item"] = "wal_e"
default["wal-e"]["s3"]["use_encrypted_data_bag"] = false
default["wal-e"]["s3"]["default_host"] = nil

default["wal-e"]["postgres_group"] = "postgres"
