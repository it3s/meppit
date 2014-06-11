module ContributorController
  extend ActiveSupport::Concern

  included do
    def contributions
      respond_to do |format|
        format.html { render :layout => !request.xhr? }
        format.js
      end
    end
  end
end
