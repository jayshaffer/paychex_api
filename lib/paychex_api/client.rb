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
    API_PATH = ''.freeze
    COMPANIES_PATH = '/companies'.freeze
    ASSOCIATIONS_PATH = '/'.freeze
    ORGANIZATIONS_PATH = '/organizations'.freeze
    JOB_TITLES_PATH = '/jobtitles'.freeze
    WORKER_STATUSES_PATH = '/workerstatuses'.freeze
    WORKERS_PATH = '/workers'.freeze
    COMMUNICATIONS_PATH = '/communications'.freeze
    COMPENSATION_PATH = '/compensation'.freeze
    DIRECT_DEPOSITS_PATH = '/directdeposits'.freeze
    PAY_PERIODS_PATH = '/payperiods'.freeze
    PAY_COMPONENTS_PATH = '/paycomponents'.freeze
    CHECKS_PATH = '/checks'.freeze
    OAUTH_TOKEN_PATH = '/auth/oauth/v2/token'.freeze

    attr_reader :authorization

    Dir[File.dirname(__FILE__) + '/client/*.rb'].each do |file|
      require file
      include const_get(File.basename(file).gsub('.rb', '').split('_').map(&:capitalize).join('').to_s)
    end

    # Override Footrest request for ApiArray support
    def request(method, &block)
      authorize if @authorization.blank? || @authorization['expiration'] <= Time.now - 30.seconds
      connection.headers[:authorization] = "Bearer #{@authorization['access_token']}"
      ApiArray.process_response(connection.send(method, &block), self)
    end

    def authorize
      response = default_faraday.post(
        OAUTH_TOKEN_PATH,
        client_id: config[:client_id],
        client_secret: config[:client_secret],
        grant_type: 'client_credentials'
      )
      @authorization = response.body
      @authorization['expiration'] = Time.now + @authorization['expires_in'].to_i.seconds
    end

    def set_connection(config)
      config[:logger] = config[:logging] if config[:logging]
      @connection = default_faraday
    end

    def faraday_default_use(faraday)
      faraday.use Footrest::ParseJson, content_type: /\bjson$/
      faraday.use Footrest::RaiseFootrestErrors
      faraday.use Footrest::Pagination
      faraday.use Footrest::FollowRedirects, limit: 5 if config[:follow_redirects]
      faraday
    end

    def faraday_default_headers(faraday)
      faraday.headers[:accept]          = 'application/json'
      faraday.headers[:user_agent]      = 'Footrest'
      faraday
    end

    def faraday_default_request(faraday)
      faraday.request :multipart
      faraday.request :url_encoded
      faraday
    end

    def faraday_logger(faraday)
      if config[:logger] == true
        faraday.response :logger
      elsif config[:logger]
        faraday.use Faraday::Response::Logger, config[:logger]
      end
      faraday
    end

    def faraday_proxy(faraday)
      faraday.proxy PaychexAPI.proxy if PaychexAPI.proxy
      faraday
    end

    def faraday_config(faraday)
      faraday = faraday_logger(faraday)
      faraday = faraday_default_request(faraday)
      faraday = faraday_default_use(faraday)
      faraday = faraday_default_headers(faraday)
      faraday = faraday_proxy(faraday)
      faraday.adapter Faraday.default_adapter
      faraday
    end

    def default_faraday
      Faraday.new(url: config[:prefix]) do |faraday|
        faraday_config(faraday)
      end
    end
  end
end
