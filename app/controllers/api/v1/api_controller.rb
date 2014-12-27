module API
  module V1
    class APIController < ApplicationController

      skip_before_filter :verify_authenticity_token, only: [:options]
      before_action :authenticate_with_token, except: [:options]
      before_filter :cors_preflight_check
      after_filter :cors_set_access_control_headers

      responders PaginateResponder, FilterResponder
      respond_to :json, :xml, :geojson

      def show
        respond_with model.find(params[:id])
      end

      def index
        respond_with model.all
      end

      def options
      end

      protected

        # curl -H "Authorization: Token token=usertokengoeshere" http://...
        def authenticate_with_token
          # TODO check the authentication type (Bearer or Token)
          # First try to authenticate using the user token, if fail try OAuth token.
          @current_resource_owner = authenticate_with_http_token do |token, opt|
            User.find_by(auth_token: token)
          end
          @current_resource_owner || doorkeeper_authorize!
        end

        def current_resource_owner
          @current_resource_owner ||= User.find_by_id(doorkeeper_token.resource_owner_id) if doorkeeper_token
          @current_resource_owner
        end

    end
  end
end
