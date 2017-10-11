[![Build Status](https://travis-ci.org/JonathanTron/chef-wal-e.svg?branch=master)](https://travis-ci.org/JonathanTron/chef-wal-e)

wal-e Cookbook
=================

Installs and configure Wal-E an S3 based WAL-shipping disaster recovery and
standby toolkit for PostgreSQL.

Requirements
------------

#### platforms
- `ubuntu` - wal-e has only been tested on ubuntu

#### cookbooks
- `runit` - for the `runit`'s `chpst` command.
- `python` - for `python`, `virtualenv` and `pip` installation and LWRP.

Attributes
----------

#### wal-e::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['wal-e']['version']</tt></td>
    <td>String</td>
    <td>which version to install</td>
    <td><tt>"0.8.1"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['install_path']</tt></td>
    <td>String</td>
    <td>full path to the wal-e install directory</td>
    <td><tt>"/opt/wal-e/"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['env_d_path']</tt></td>
    <td>String</td>
    <td>path to the daemontool's env.d path for Wal-E configurations</td>
    <td><tt>"/etc/wal-e.d"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['env_path']</tt></td>
    <td>String</td>
    <td>path to the daemontool's env path for Wal-E configurations</td>
    <td><tt>"/etc/wal-e.d/env"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['exe_path']</tt></td>
    <td>String</td>
    <td>full path to the wal-e executable</td>
    <td><tt>"/opt/wal-e/bin/wal-e"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['exe_with_env']</tt></td>
    <td>String</td>
    <td>command to use to have the full configuration via environment variable</td>
    <td><tt>"chpst -e /etc/wal-e.d/env /opt/wal-e/bin/wal-e"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['s3']['data_bag']</tt></td>
    <td>String</td>
    <td>name of the data_bag holding the s3 configuration</td>
    <td><tt>"aws_credentials"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['s3']['data_bag_item']</tt></td>
    <td>String</td>
    <td>name of the data_bag's item holding the s3 configuration</td>
    <td><tt>"wal_e"</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['s3']['use_encrypted_data_bag']</tt></td>
    <td>Boolean</td>
    <td>if the data_bag is expected to be encrypted or not</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['s3']['default_host']</tt></td>
    <td>String</td>
    <td>
      a default host used to configure boto. This is required to ensure all
      commands work correctly when bucket is not created in the default S3 zone.
      The list of possible host can be found at [AWS S3 Endpoint list](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region).
      If no value is set then no boto's config file is created.
    </td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['wal-e']['postgres_group']</tt></td>
    <td>String</td>
    <td>the group of the postgres user, wal-e should be executable for it</td>
    <td><tt>postgres</tt></td>
  </tr>
</table>

Usage
-----

#### S3 credentials

To either ship WAL or recover from S3, you will have to configure the S3
credentials and bucket to use. This cookbook expects to find them in a
`data_bag` (encrypted or not).

By default the S3 configuration is expected to be found in an `aws_credentials`
`data_bag`, in a `wal_e` `data_bag item`.

Here's the expected content of such a `data_bag item`:

```json
{
  "id": "wal_e",
  "secret_access_key": "xxxxxxx",
  "access_key_id": "xxxxxxx",
  "bucket": "postgresql-backup",
  "region": "us-east-1"
}
```

Optionally you can also specify the GPG key to use to encrypt each WAL segment
before they are sent to S3.
Please note that we don't install nor configure GPG, we're expecting the key id
is already setup correctly on the machine. To backup, only the public key is
needed, but for recovery the private key needs to be there. See
[Wal-E Encryption doc](https://github.com/wal-e/wal-e#encryption) for more
details.

```json
{
  "id": "wal_e",
  "secret_access_key": "xxxxxxx",
  "access_key_id": "xxxxxxx",
  "bucket": "postgresql-backup",
  "region": "us-east-1",
  "gpg_key_id": "0xBB9E4B35"
}
```

#### To install and configure wal-e

Include `wal-e` or more explictly `wal-e::default` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[wal-e::default]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Author:: Jonathan Tron (<jonathan@openhood.com>)

Copyright 2013, Openhood S.E.N.C.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
