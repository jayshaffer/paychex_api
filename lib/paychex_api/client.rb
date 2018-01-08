require 'footrest/client'
require 'faraday'
require 'footrest'
require 'footrest/http_error'
require 'footrest/pagination'
require 'footrest/follow_redirects'
require 'footrest/parse_json'
require 'base64'
require 'active_support/time'
require 'paychex_api/api_array'

module PaychexAPI
  class Client < Footrest::Client

    API_PATH = ""
    COMPANIES_PATH = '/companies'
    ORGANIZATIONS_PATH = '/organizations'
    JOB_TITLES_PATH = '/jobtitles'
    WORKER_STATUSES_PATH = '/workerstatuses'
    WORKERS_PATH = '/workers'
    COMMUNICATIONS_PATH = '/communications'
    COMPENSATION_PATH = '/compensation'
    DIRECT_DEPOSITS_PATH = '/directdeposits'
    PAY_PERIODS_PATH = '/payperiods'
    PAY_COMPONENTS_PATH = '/paycomponents'
    CHECKS_PATH = '/checks'
    OAUTH_TOKEN_PATH = '/auth/oauth/v2/token'

    attr_reader :authorization

    Dir[File.dirname(__FILE__) + '/client/*.rb'].each do |file|
      require file
      include self.const_get("#{File.basename(file).gsub('.rb','').split("_").map{|ea| ea.capitalize}.join('')}")
    end

    # Override Footrest request for ApiArray support
    def request(method, &block)
      if @authorization.blank? || @authorization['expiration'] <= DateTime.now - 30.seconds
        temp_client =  get_default_faraday
        response = temp_client.post(
          OAUTH_TOKEN_PATH,
          {
            client_id: config[:client_id],
            client_secret: config[:client_secret],
            grant_type: 'client_credentials'
          }
        )
        @authorization = response.body
        @authorization['expiration'] = DateTime.now + @authorization['expires_in'].to_i.seconds
      end
      connection.headers[:authorization] =   "Bearer #{@authorization['access_token']}"
      ApiArray::process_response(connection.send(method, &block), self)
    end

    def set_connection(config)
      config[:logger] = config[:logging] if config[:logging]
      @connection = get_default_faraday
    end

    def get_default_faraday
      Faraday.new(url: config[:prefix]) do |faraday|
        faraday.request                     :multipart
        faraday.request                     :url_encoded
        if config[:logger] == true
          faraday.response :logger
        elsif config[:logger]
          faraday.use Faraday::Response::Logger, config[:logger]
        end
        faraday.use                         Footrest::FollowRedirects, limit: 5 unless config[:follow_redirects] == false
        faraday.adapter                     Faraday.default_adapter
        faraday.use                         Footrest::ParseJson, :content_type => /\bjson$/
        faraday.use                         Footrest::RaiseFootrestErrors
        faraday.use                         Footrest::Pagination
        faraday.headers[:accept]          = "application/json"
        faraday.headers[:user_agent]      = "Footrest"
      end
    end
  end
end
