module PaychexAPI
  class Client
    module Associations
      def get_association_companies(association_id, params = {})
        connection.headers[:accept] = "application/json;profile='https://api.paychex.com/profiles/association_companies/v1"
        get("#{API_PATH}#{COMPANIES_PATH}?association_id=#{association_id}", params)
      end
    end
  end
end
