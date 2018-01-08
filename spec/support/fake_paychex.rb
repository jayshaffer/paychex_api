require 'sinatra/base'
require 'tilt'

class FakePaychex < Sinatra::Base

  #auth
  post %r{/auth/oauth/v2/token$} do
    get_json_data 200, 'auth.json'
  end

  #workers
  get %r{/companies/\d+/workers$} do
    get_json_data 200, 'workers.json'
  end

  get %r{/workers/\d+/communications$} do
    get_json_data 200, 'communications.json'
  end

  get %r{/workers/\d+/communications/\d+$} do
    get_json_data 200, 'communications.json'
  end

  post %r{/workers/\d+/communications$} do
    get_json_data 200, 'communications.json'
  end

  put %r{/workers/\d+/communications/\d+$} do
    get_json_data 200, 'communications.json'
  end

  delete %r{/workers/\d+/communications/\d+$} do
    get_json_data 200, 'communications.json'
  end

  #companies
  get %r{/companies/\d+$} do
    get_json_data 200, 'companies.json'
  end

  get %r{/companies$} do
    get_json_data 200, 'companies.json'
  end

  get %r{/companies/\d/organizations+$} do
    get_json_data 200, 'organizations.json'
  end

  private

  def get_json_data(response_code, file_name)
    content_type :json
    status response_code
    unless file_name.nil?
      File.open(File.dirname(__FILE__) + '/../fixtures/' + file_name).read
    else
      {}
    end
  end

end
