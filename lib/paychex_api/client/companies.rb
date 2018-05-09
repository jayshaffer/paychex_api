module PaychexAPI
  class Client
    module Companies
      def get_company(company_id, params = {})
        get("#{API_PATH}#{COMPANIES_PATH}/#{company_id}", params)
      end

      def get_company_associations(company_id, params = {})
        connection.headers[:accept] = "application/json;profile='https://api.paychex.com/profiles/company_associations/v1"
        get("#{API_PATH}#{COMPANIES_PATH}/#{company_id}", params)
      end

      def get_company_by_display_id(display_id, params = {})
        params = params.merge(displayid: display_id)
        get("#{API_PATH}#{COMPANIES_PATH}", params)
      end

      def get_organizations(company_id, _organization_id, params = {})
        get("#{API_PATH}#{COMPANIES_PATH}/#{company_id}#{ORGANIZATIONS_PATH}", params)
      end

      def get_organization(company_id, organization_id, params = {})
        get("#{API_PATH}#{COMPANIES_PATH}/#{company_id}#{ORGANIZATIONS_PATH}/#{organization_id}", params)
      end
    end
  end
end
