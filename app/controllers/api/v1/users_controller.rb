module API
  module V1
    class UsersController < APIController

      def model; User end

      def me
        respond_with current_resource_owner
      end

    end
  end
end
