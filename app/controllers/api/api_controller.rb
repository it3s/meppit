module API
  class APIController < ApplicationController
    protect_from_forgery with: :null_session

    # curl -H "Authorization: Token token=usertokengoeshere" http://...
    def authenticate_or_resquest
      authenticate_or_request_with_http_token do |token, opt|
        User.find_by(auth_token: token).present?
      end
    end

  end
end
