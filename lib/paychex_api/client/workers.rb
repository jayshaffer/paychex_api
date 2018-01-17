module PaychexAPI
  class Client
    module Workers

      def get_all_workers(company_id, params = {})
        get("#{API_PATH}#{COMPANIES_PATH}/#{company_id}#{WORKERS_PATH}", params)
      end

      def get_worker(worker_id, params = {})
        get("#{API_PATH}#{WORKERS_PATH}/#{worker_id}", params)
      end

      def get_communications(worker_id, params = {})
        get("#{API_PATH}#{WORKERS_PATH}/#{worker_id}#{COMMUNICATIONS_PATH}", params)
      end

      def get_communication(worker_id, communication_id, params = {})
        get("#{API_PATH}#{WORKERS_PATH}/#{worker_id}#{COMMUNICATIONS_PATH}/#{communication_id}", params)
      end

      def create_communication(worker_id, params = {})
        post("#{API_PATH}#{WORKERS_PATH}/#{worker_id}#{COMMUNICATIONS_PATH}", params)
      end

      def update_communication(worker_id, communication_id, params = {})
        put("#{API_PATH}#{WORKERS_PATH}/#{worker_id}#{COMMUNICATIONS_PATH}/#{communication_id}", params)
      end

      def delete_communication(worker_id, communication_id, params = {})
        delete("#{API_PATH}#{WORKERS_PATH}/#{worker_id}#{COMMUNICATIONS_PATH}/#{communication_id}", params)
      end

    end
  end
end
