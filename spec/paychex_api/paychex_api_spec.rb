require 'test_helper'

describe PaychexAPI do
  it 'should set a proxy for the client' do
    client = PaychexAPI::Client.new(
      prefix: 'http://test.paychex.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    expect(PaychexAPI.proxy).to eq(nil)
    PaychexAPI.configure do |config|
      config.proxy = 'http://google.com'
    end
    expect(PaychexAPI.proxy).to eq('http://google.com')
    response = client.get_communications(1)
    expect(response.first['communicationId']).to(eq('00Z5V9BTINBT97UMERCA'))
  end
end
