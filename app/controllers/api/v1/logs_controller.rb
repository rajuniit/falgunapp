module Api
  module V1
    class LogsController < Api::V1::ApiController

      def create
        data = parse_post_params(params)
        @log_error = LogError.new(data)

        if @log_error.save
          handle_api_response @log_error.to_api_hash
        else
          handle_api_error(@log_error)
        end

      end

      protected

      def parse_post_params(params)
        data = {}
        data[:title] = params[:title] if params[:title].present?
        data[:data] = params[:data] if params[:data].present?
        data[:log_key] = params[:log_key] if params[:log_key].present?

        data
      end

    end
  end
end
