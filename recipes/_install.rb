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

include_recipe "runit"

# Install dependencies
package "lzop"
package "pv"
package "libevent-dev"
package "libffi-dev"


if node["platform_version"] =~ /^12.04/
  # Ensure python 2.x is installed
  python_runtime "2"

  # Create a virtualenv for wal-e
  python_virtualenv node["wal-e"]["install_path"] do
    user "root"
    group node["wal-e"]["postgres_group"]
    python "2"
    action :create
  end

  # Ensure we're using compatible greenlet/gevent version on ubuntu 12.04
  python_package "greenlet" do
    virtualenv node["wal-e"]["install_path"]
    version "0.4.9"
  end
  python_package "gevent" do
    virtualenv node["wal-e"]["install_path"]
    version "0.13.8"
  end
else
  # Ensure python 3.x is installed
  python_runtime "3"

  # Create a virtualenv for wal-e
  python_virtualenv node["wal-e"]["install_path"] do
    user "root"
    group node["wal-e"]["postgres_group"]
    python "3"
    action :create
  end
end

# Install wal-e via pip in a virtualenv
python_package "wal-e" do
  virtualenv node["wal-e"]["install_path"]
  version node["wal-e"]["version"]
end
