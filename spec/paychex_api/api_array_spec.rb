require 'test_helper'
require 'byebug'

describe PaychexAPI::ApiArray do
  it 'should check the length of a response' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    expect(workers.length).to eq(1)
  end

  it 'should have an array indexer' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    expect(workers[0]['workerId']).to eq('00Z5V9BTIHRQF2CF7BTH')
  end

  it 'should have a pages check' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    expect(workers.pages?).to eq(true)
  end

  it 'should have a last accessor' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    expect(workers.last['workerId']).to eq('00Z5V9BTIHRQF2CF7BTH')
  end

  it 'should have a next page accessor' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    expect(workers.next_page.length).to eq(1)
  end

  it 'should have an each page generator' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    result = []
    expect(result.size).to eq(0)
    counter = 0
    workers.each_page do |page|
      result.concat page
      workers.next_page = nil if counter > 2
      counter += 1
    end
    expect(result.size).to eq(4)
  end

  it 'should have an all pages function' do
    client = PaychexAPI::Client.new(
      prefix: 'https://www.fake.com', client_id: 'client_id', client_secret: 'client_secret'
    )
    workers = client.get_all_workers('1')
    results = workers.all_pages!
    expect(results.length).to eq(103)
  end
end
