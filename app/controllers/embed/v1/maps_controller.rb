module Embed
  module V1
    class MapsController < EmbedController
      before_action :find_map, only: [:show]

      def show
      end

      def help
        render layout: nil
      end

      private

      def find_map
        @map = Map.find(params[:id])
      end
    end
  end
end
