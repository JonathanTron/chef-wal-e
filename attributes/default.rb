include_attribute "poise-python::default"

case node["platform_version"]
when /^12.04/
  default["wal-e"]["version"] = "0.9.2"
else
  default["wal-e"]["version"] = "1.1.0"
end

default["wal-e"]["install_path"] = "/opt/wal-e/"
default["wal-e"]["env_d_path"] = "/etc/wal-e.d/"
default["wal-e"]["env_path"] = ::File.join default["wal-e"]["env_d_path"], "env"
default["wal-e"]["exe_path"] = "/opt/wal-e/bin/wal-e"
default["wal-e"]["exe_with_env"] = "chpst -e #{default["wal-e"]["env_path"]} #{default["wal-e"]["exe_path"]}"

default["wal-e"]["s3"]["data_bag"] = "aws_credentials"
default["wal-e"]["s3"]["data_bag_item"] = "wal_e"
default["wal-e"]["s3"]["use_encrypted_data_bag"] = false
default["wal-e"]["s3"]["default_host"] = nil

default["wal-e"]["postgres_group"] = "postgres"
