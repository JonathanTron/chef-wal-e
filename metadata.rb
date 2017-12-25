name             "wal-e"
maintainer       "Openhood S.E.N.C"
maintainer_email "jonathan@openhood.com"
license          "Apache-2.0"
description      "Installs/Configures Wal-E"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.8.1"

supports "ubuntu"

depends "poise-python"
depends "runit"

source_url       "https://github.com/JonathanTron/chef-wal-e"
issues_url       "https://github.com/JonathanTron/chef-wal-e/issues"
chef_version     '>= 12.1' if respond_to?(:chef_version)
