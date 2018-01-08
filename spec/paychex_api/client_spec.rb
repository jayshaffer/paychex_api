require 'test_helper'

describe PaychexAPI::Client do

  it 'should pull the auth token' do
    client = PaychexAPI::Client.new(prefix: "https://www.fake.com", client_id: "client_id", client_secret: 'client_secret')
    client.get_all_workers("1")
    expect(client.authorization['access_token']).to(eq('99f9c30a-8134-4a30-a789-7c7665add41e'))
  end

  it 'should skip pulling the auth token' do
    client = PaychexAPI::Client.new(prefix: "https://www.fake.com", client_id: "client_id", client_secret: 'client_secret')
    expect(client.authorization).to(eq(nil))
    client.get_all_workers("1")
    expect(client.authorization['access_token']).to(eq('99f9c30a-8134-4a30-a789-7c7665add41e'))
    expect_any_instance_of(Faraday).not_to receive(:post)
    client.get_all_workers("1")
  end

  it 'should set the auth header to bearer auth' do
    client = PaychexAPI::Client.new(prefix: "https://www.fake.com", client_id: "client_id", client_secret: 'client_secret')
    client.get_all_workers("1")
    expect(client.connection.headers['Authorization']).to(eq("Bearer 99f9c30a-8134-4a30-a789-7c7665add41e"))
  end

end
