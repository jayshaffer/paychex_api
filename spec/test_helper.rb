require 'paychex_api'
require 'rspec'
require 'webmock/rspec'
require 'json'
require 'pry'
require 'byebug'

RSpec.configure do |config|
  Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

  config.before(:each) do
    WebMock.disable_net_connect!
    WebMock.stub_request(:any, /.*/).to_rack(FakePaychex)
  end
end


def fixture(*file)
  File.new(File.join(File.expand_path("../fixtures", __FILE__), *file))
end
