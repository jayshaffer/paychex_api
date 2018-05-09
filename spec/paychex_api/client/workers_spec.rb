require 'test_helper'
describe PaychexAPI::Client::Workers do
  before do
    @client = PaychexAPI::Client.new(
      prefix: 'http://test.paychex.com', client_id: 'client_id', client_secret: 'client_secret'
    )
  end

  it 'should get all workers' do
    response = @client.get_all_workers('1')
    expect(response.first['workerId']).to(eq('00Z5V9BTIHRQF2CF7BTH'))
  end

  it 'should get a single worker' do
    response = @client.get_worker('1')
    expect(response.first['workerId']).to(eq('00Z5V9BTIHRQF2CF7BTH'))
  end

  it 'should get all communications' do
    response = @client.get_communications(1)
    expect(response.first['communicationId']).to(eq('00Z5V9BTINBT97UMERCA'))
  end

  it 'should get a communication' do
    response = @client.get_communication(1, 1)
    expect(response.first['communicationId']).to(eq('00Z5V9BTINBT97UMERCA'))
  end

  it 'should get create a communication' do
    response = @client.create_communication(1)
    expect(response.first['communicationId']).to(eq('00Z5V9BTINBT97UMERCA'))
  end

  it 'should update a communication' do
    response = @client.update_communication(1, 1, something: 'something')
    expect(response.first['communicationId']).to(eq('00Z5V9BTINBT97UMERCA'))
  end
end
