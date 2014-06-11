module Contributions
  extend ActiveSupport::Concern

  def contributions
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.js
    end
  end

end
