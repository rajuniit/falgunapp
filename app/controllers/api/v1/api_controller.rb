module Api
  module V1
    class ApiController < ActionController::Base

      API_VERSION = '1'
      before_filter :login_required

      protected

      def handle_api_response(options={})
        content = {:json => options.to_json}
        response.headers['FALGUN-API-VERSION'] = API_VERSION
        respond_to do |f|
          f.any(:json, :js, :text, :html) { render content}
        end
      end

      def api_error(status_code, options={})
        errors = {}
        errors[:type] = options[:type] if options[:type]
        errors[:message] = options[:message] if options[:message]
        content = {:json => {:errors => errors}.to_json, :status => status_code}

        response.headers['FALGUN-API-VERSION'] = API_VERSION

        respond_to do |f|
          f.any(:json, :js, :text, :html) { render content}
        end
      end

      def handle_api_error(object, options={})
        errors = object.try(:errors) || {}
        errors[:type] = 'InvalidRecord'
        errors[:message] = "One or more fields were invalid"
        content = {:json => {:errors => errors}.to_json, :status => options.delete(:status) || :unprocessable_entity}
        response.headers['FALGUN-API-VERSION'] = API_VERSION

        respond_to do |f|
          f.any {render content}
        end
      end

      def login_required
        authorized? || access_denied
      end

      def authorized?
        logged_in?
      end

      def logged_in?
        !!logged_in_user
      end

      def access_denied
        api_error(:unauthorized, :type => 'AuthorizationFailed', :message => @access_denied_message || 'Login required')
      end

      def logged_in_user
        #@logged_in_user ||= (login_from_session || login_from_basic_auth || login_from_auth_token || login_from_key_and_api_code) unless @logged_in_user == false
        @logged_in_user ||= (login_from_key_and_api_code) unless @logged_in_user == false
      end

      def login_from_session
        #devise current_user method
        @logged_in_user = current_user
      end

      def login_from_basic_auth
        authenticate_with_http_basic do |login, password|
          user = User.find_by_email(login)
          @logged_in_user = user if user && user.valid_password?(password)
        end
      end

      def login_from_auth_token
        authenticate_or_request_with_http_token do |auth_token, options|
          @logged_in_user = User.exists?(authentication_token:auth_token)
        end
      end

      def login_from_key_and_api_code
        log = Log.where(key: params[:log_key])
        if log.count > 0
          @logged_in_user = log.first.user if log.first.api_code == params[:code]
        end
      end


    end
  end

end