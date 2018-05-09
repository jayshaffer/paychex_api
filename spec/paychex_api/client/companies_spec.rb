require 'test_helper'
describe PaychexAPI::Client::Companies do
  before do
    @client = PaychexAPI::Client.new(
      prefix: 'http://test.paychex.com', client_id: 'client_id', client_secret: 'client_secret'
    )
  end

  it 'should get a company' do
    response = @client.get_company(1, something: 'something')
    expect(response.first['companyId']).to(eq('99Z5V9BTI8J2FCGESC05'))
  end

  it 'should get company associations' do
    response = @client.get_company_associations(1, something: 'something')
    expect(response.first['companyId']).to(eq('99Z5V9BTI8J2FCGESC05'))
  end

  it 'should get a company by display id' do
    response = @client.get_company_by_display_id(1)
    expect(response.first['companyId']).to(eq('99Z5V9BTI8J2FCGESC05'))
  end

  it 'should get organizations' do
    response = @client.get_organizations(1, 2)
    expect(response.first['organizationId']).to(eq('970000055981384'))
  end
end
