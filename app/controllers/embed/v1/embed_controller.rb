module Embed
  module V1
    class EmbedController < ApplicationController
      before_action :set_size
      after_action :allow_iframe

      layout "embed"

      private

      def set_size
        @height = params[:height] || '100%'
        @width  = params[:width]  || '100%'
      end

      def allow_iframe
        response.headers['X-Frame-Options'] = "ALLOWALL"
      end

    end
  end
end
