$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'encodable_validator'
require 'active_model'
require 'simplecov'

SimpleCov.start do
  add_group 'Lib', 'lib'
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

class TestRecord
  include ActiveModel::Validations
  attr_accessor :target_text

  def initialize(target_text)
    @target_text = target_text
  end
end
