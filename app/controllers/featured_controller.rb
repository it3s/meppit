class FeaturedController < ApplicationController

  before_action :is_admin
  before_action :find_featurable

  def create
    @featurable.featured = true
    featured_button_json_response()
  end

  def destroy
    @featurable.featured = false
    featured_button_json_response()
  end

  private

    def find_featurable
      @featurable = find_polymorphic_object
    end

    def featured_button_json_response
      render json: {ok: true, featured: @featurable.featured?}
    end
end
