require File.expand_path('../support/helpers', __FILE__)

describe 'wal-e_test::encrypted_data_bag' do

  include Helpers::WalETest

  describe "S3 configurations" do
    it "sets AWS_SECRET_ACCESS_KEY" do
      file("/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY").must_include "another_secret"
    end

    it "sets AWS_ACCESS_KEY_ID" do
      file("/etc/wal-e.d/env/AWS_ACCESS_KEY_ID").must_include "Captain B. McCrea"
    end

    it "sets WALE_S3_PREFIX" do
      file("/etc/wal-e.d/env/WALE_S3_PREFIX").must_include(
        "s3://pg-backups/#{node[:fqdn]}/wal-e"
      )
    end

    it "sets WALE_GPG_KEY_ID" do
      file("/etc/wal-e.d/env/WALE_GPG_KEY_ID").must_include "0xBB9E4B35"
    end
  end

end
