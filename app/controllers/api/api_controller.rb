module API
  class APIController < ApplicationController

    protected

      def authenticate_or_resquest
        authenticate_or_resquest_with_http_token do |token, opt|
          User.find_by auth_token: token
        end
      end
  end
end
