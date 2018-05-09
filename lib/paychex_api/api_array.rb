
module PaychexAPI
  class ApiArray
    include Enumerable

    MAX_PAGES = 100

    @next_page = nil
    @prev_page = nil

    attr_reader :status, :headers, :members, :links, :metadata
    attr_writer :next_page

    def self.process_response(response, api_client)
      ApiArray.new(response, api_client)
    end

    def initialize(response, api_client)
      @meta_fields = %w[metadata links]
      @api_client = api_client
      @links = []
      @metadata = {}
      case response.status
      when *((200..206).to_a + [302])
        apply_response_metadata(response)
        @members = get_response_content(response)
      end
    end

    def length
      @members.length
    end

    def [](index)
      @members[index]
    end

    def last
      @members.last
    end

    def each
      @members.each { |member| yield(member) }
    end

    def pages?
      !@next_page.nil?
    end

    def next_page
      load_page(@next_page)
    end

    def each_page
      yield(@members, @linked, @meta)
      while @next_page
        response = get_page(@next_page)
        apply_response_metadata(response, false)
        @members = get_response_content(response)
        yield(@members, @linked, @meta)
      end
      @link_hash = {}
    end

    def all_pages!
      return self unless pages?
      combine_page
      combine_pages
      self
    end

    private

    def combine_pages
      counter = 0
      while @next_page && counter <= MAX_PAGES
        combine_page
        counter += 1
      end
    end

    def combine_page
      response = get_page(@next_page)
      apply_response_metadata(response)
      @members.concat(get_response_content(response))
    end

    def get_page(url, params = {})
      query = URI.parse(url).query
      p = CGI.parse(query).merge(params)
      u = url.gsub("?#{query}", '')
      p.each { |k, v| p[k] = v.first if v.is_a?(Array) }
      @api_client.connection.send(:get) do |r|
        r.url(u, p)
      end
    end

    def load_page(url)
      response = get_page(url)
      ApiArray.process_response(response, @api_client)
    end

    def get_response_content(response)
      return [] unless response.body.is_a?(Hash)
      content = response.body['content']
      return content unless content.empty?
      []
    end

    def apply_response_metadata(response, concat = true)
      unless concat
        @links = []
        @metadata = {}
      end
      @status = response.status
      @headers = response.headers
      @method = response.env[:method]
      init_pages(response)
      init_linked(response)
      init_meta(response)
    end

    def init_linked(response)
      return nil unless response.body.is_a?(Hash) && response.body.key?('links')
      @links = @links.concat(response.body['links'])
    end

    def init_meta(response)
      return nil unless response.body.is_a?(Hash) && response.body.key?('metadata')
      @metadata = response.body['metadata']
    end

    def init_pages(response)
      return nil unless response.body.is_a?(Hash) && response.body.key?('links')
      @next_page, @prev_page = nil
      response.body['links'].each do |link|
        case link['rel']
        when 'next'
          @next_page = link['href']
        when 'prev'
          @prev_page = link['href']
        end
      end
    end
  end
end
