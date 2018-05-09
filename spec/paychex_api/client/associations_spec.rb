require 'test_helper'
describe PaychexAPI::Client::Associations do
  before do
    @client = PaychexAPI::Client.new(
      prefix: 'http://test.paychex.com', client_id: 'client_id', client_secret: 'client_secret'
    )
  end

  it 'should get a association companies' do
    response = @client.get_association_companies(1)
    expect(response.first['companyId']).to(eq('99Z5V9BTI8J2FCGESC05'))
  end
end
