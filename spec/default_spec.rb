require 'spec_helper'

['12.04', '16.04'].each do |ubuntu_version|
  describe 'wal-e::default' do
    before do
      Chef::Config[:config_file] = '/dev/null'
      stub_data_bag_item('aws_credentials', 'wal_e').and_return({
        secret_access_key: 'secret',
        access_key_id: 'secret_access_key',
        region: 'aws_region',
        bucket: 'eve',
      })
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: "ubuntu",
        version: ubuntu_version
      ).converge described_recipe
    end

    context 'with default attributes' do
      it 'loads runit::default recipe' do
        expect(chef_run).to include_recipe 'runit::default'
      end

      it 'installs package lzop' do
        expect(chef_run).to install_package 'lzop'
      end

      it 'installs package pv' do
        expect(chef_run).to install_package 'pv'
      end

      it 'installs package libevent-dev' do
        expect(chef_run).to install_package 'libevent-dev'
      end

      it 'installs package libffi-dev' do
        expect(chef_run).to install_package 'libffi-dev'
      end

      if ubuntu_version=='12.04'
        it 'installs python 2.x' do
          expect(chef_run).to install_python_runtime('2')
        end

        it 'creates a python virtualenv for wal-e' do
          expect(chef_run).to create_python_virtualenv('/opt/wal-e/').with(
            user: 'root',
            group: 'postgres',
            python: '/usr/bin/python2.7'
          )
        end

        it 'installs wal-e via pip in virtualenv' do
          expect(chef_run).to install_python_package('wal-e').with(
            # virtualenv: '/opt/wal-e/',
            version: '0.9.2'
          )
        end

        it 'installs greenlet 0.4.9 via pip in virtualenv' do
          expect(chef_run).to install_python_package('greenlet').with(
            # virtualenv: '/opt/wal-e/',
            version: '0.4.9'
          )
        end

        it 'installs gevent 0.13.8 via pip in virtualenv' do
          expect(chef_run).to install_python_package('gevent').with(
            # virtualenv: '/opt/wal-e/',
            version: '0.13.8'
          )
        end
      else
        it 'installs python 3.x' do
          expect(chef_run).to install_python_runtime('3')
        end

        it 'creates a python virtualenv for wal-e' do
          expect(chef_run).to create_python_virtualenv('/opt/wal-e/').with(
            user: 'root',
            group: 'postgres',
            python: '/usr/bin/python3.5'
          )
        end

        it 'installs wal-e via pip in virtualenv' do
          expect(chef_run).to install_python_package('wal-e').with(
            # virtualenv: '/opt/wal-e/',
            version: '1.1.0'
          )
        end

        it 'does not install greenlet via pip in virtualenv' do
          expect(chef_run).not_to install_python_package('greenlet')
        end

        it 'does not install gevent via pip in virtualenv' do
          expect(chef_run).not_to install_python_package('gevent')
        end
      end

      it 'creates base directory for configs' do
        expect(chef_run).to create_directory('/etc/wal-e.d/').with(
          owner: 'root',
          group: 'postgres',
          mode: '0750'
        )
      end

      it 'creates env directory for configs' do
        expect(chef_run).to create_directory('/etc/wal-e.d/env').with(
          owner: 'root',
          group: 'postgres',
          mode: '0750'
        )
      end

      it 'creates file for AWS_SECRET_ACCESS_KEY' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY'
        ).with_content 'secret'
      end

      it 'creates file for AWS_ACCESS_KEY_ID' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/AWS_ACCESS_KEY_ID'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/AWS_ACCESS_KEY_ID'
        ).with_content 'secret_access_key'
      end

      it 'creates file for AWS_REGION' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/AWS_REGION'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/AWS_REGION'
        ).with_content 'aws_region'
      end

      it 'creates file for WALE_S3_PREFIX' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/WALE_S3_PREFIX'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/WALE_S3_PREFIX'
        ).with_content 's3://eve/fauxhai.local/wal-e'
      end

      it 'creates file for WALE_GPG_KEY_ID' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/WALE_GPG_KEY_ID'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/WALE_GPG_KEY_ID'
        ).with_content ""
      end

      it 'deletes /etc/boto.cfg' do
        expect(chef_run).to delete_file '/etc/boto.cfg'
      end
    end

    context 'setting an s3 default host' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: "ubuntu",
          version: ubuntu_version
        ) do |node|
          node.override['wal-e']['s3']['default_host'] = 's3_default_host'
        end.converge described_recipe
      end

      it 'creates a boto config file' do
        expect(chef_run).to create_template('/etc/boto.cfg').with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
      end

      it 'sets the default host from attribute' do
        expect(chef_run).to render_file('/etc/boto.cfg').with_content(
          /\[s3\]\nhost=s3_default_host/
        )
      end
    end

    context 'using encrypted databag' do

      before do
        stub_data_bag_item('aws_credentials', 'wal_e_encrypted').and_return({
          secret_access_key: 'secret_from_encrypted',
          access_key_id: 'secret_access_key_from_encrypted',
          region: 'aws_region_from_encrypted',
          bucket: 'eve_from_encrypted',
        })
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: "ubuntu",
          version: ubuntu_version
        ) do |node|
          node.override['wal-e']['s3']['use_encrypted_data_bag'] = true
          node.override['wal-e']['s3']['data_bag_item'] = 'wal_e_encrypted'
        end.converge described_recipe
      end

      it 'creates file for AWS_SECRET_ACCESS_KEY' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY'
        ).with_content 'secret_from_encrypted'
      end

      it 'creates file for AWS_ACCESS_KEY_ID' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/AWS_ACCESS_KEY_ID'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/AWS_ACCESS_KEY_ID'
        ).with_content 'secret_access_key_from_encrypted'
      end

      it 'creates file for AWS_REGION' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/AWS_REGION'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/AWS_REGION'
        ).with_content 'aws_region_from_encrypted'
      end

      it 'creates file for WALE_S3_PREFIX' do
        expect(chef_run).to create_file(
          '/etc/wal-e.d/env/WALE_S3_PREFIX'
        ).with(
          owner: 'root',
          group: 'postgres',
          mode: '0750',
        )
        expect(chef_run).to render_file(
          '/etc/wal-e.d/env/WALE_S3_PREFIX'
        ).with_content 's3://eve_from_encrypted/fauxhai.local/wal-e'
      end

    end
  end
end
