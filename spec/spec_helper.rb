require 'chefspec'
require 'chefspec/berkshelf'
require 'support/matchers'

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'
  config.include ChefSpecMatchers
end
