$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'vimius'

include TechnoGate
include Vimius

RSpec.configure do |config|
  def config.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]'))
  end unless config.respond_to? :escaped_path

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # config.mock_with :rspec
end

# Include support files.
Dir["#{VIMIUS_SPEC_PATH}/support/**/*.rb"].each { |f| require f }
