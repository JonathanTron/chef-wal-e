#
# Cookbook Name:: wal-e
# Recipe:: _install
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

include_recipe "python"
include_recipe "runit"

# Install dependencies
package "lzop"
package "pv"
package "libevent-dev"
package "libffi-dev"

# Create a virtualenv for wal-e
python_virtualenv node["wal-e"]["install_path"] do
  owner "root"
  group node["wal-e"]["postgres_group"]
  action :create
end

if node.platform=="ubuntu" && node.platform_version =~ /^12.04/
  # Ensure we're using compatible greenlet version on ubuntu 12.04
  python_pip "greenlet" do
    virtualenv node["wal-e"]["install_path"]
    version "0.4.9"
    options "--no-binary"
  end
end

# Install wal-e via pip in a virtualenv
python_pip "wal-e" do
  virtualenv node["wal-e"]["install_path"]
  version node["wal-e"]["version"]
end
