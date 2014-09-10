#
# Cookbook Name:: wal-e
# Recipe:: _configure
#
# Copyright 2013, Openhood S.E.N.C.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

postgres_group = node["wal-e"]["postgres_group"]

# Prepare envdir for wal-e s3 configs
directory node["wal-e"]["env_d_path"] do
  owner "root"
  group postgres_group
  mode "0750"
  action :create
end

wal_e_env_path = node["wal-e"]["env_path"]
s3_config = if node["wal-e"]["s3"]["use_encrypted_data_bag"]
  Chef::EncryptedDataBagItem.load(
    node["wal-e"]["s3"]["data_bag"],
    node["wal-e"]["s3"]["data_bag_item"]
  )
else
  data_bag_item(
    node["wal-e"]["s3"]["data_bag"],
    node["wal-e"]["s3"]["data_bag_item"]
  )
end

Chef::Application.fatal!(
  "Could not find " +
  "item: #{node["wal-e"]["s3"]["data_bag_item"]} " +
  "in databag #{node["wal-e"]["s3"]["data_bag"]}"
) unless s3_config

Chef::Application.fatal!(
  "Could not find secret_access_key"
) unless s3_config["secret_access_key"]
Chef::Application.fatal!(
  "Could not find access_key_id"
) unless s3_config["access_key_id"]
Chef::Application.fatal!(
  "Could not find bucket"
) unless s3_config["bucket"]

directory wal_e_env_path do
  owner "root"
  group postgres_group
  mode "0750"
  action :create
end

file "#{wal_e_env_path}/AWS_SECRET_ACCESS_KEY" do
  owner "root"
  group postgres_group
  mode "0750"
  action :create
  content s3_config["secret_access_key"]
end

file "#{wal_e_env_path}/AWS_ACCESS_KEY_ID" do
  owner "root"
  group postgres_group
  mode "0750"
  action :create
  content s3_config["access_key_id"]
end

file "#{wal_e_env_path}/WALE_S3_PREFIX" do
  owner "root"
  group postgres_group
  mode "0750"
  action :create
  content "s3://#{s3_config["bucket"]}/#{node["fqdn"]}/wal-e"
end

file "#{wal_e_env_path}/WALE_GPG_KEY_ID" do
  owner "root"
  group postgres_group
  mode "0750"
  action :create
  content s3_config["gpg_key_id"].to_s
end

if s3_default_host = node["wal-e"]["s3"]["default_host"]
  template "/etc/boto.cfg" do
    source "boto.cfg.erb"
    owner "root"
    group postgres_group
    mode "0750"
    variables({
      s3_default_host: s3_default_host
    })
  end
else
  file "/etc/boto.cfg" do
    action :delete
  end
end
