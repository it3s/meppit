class FeaturedController < ApplicationController

  # TODO: uncomments after merging `flag`
  #before_action :is_admin
  before_action :find_featurable

  def create
    @featurable.featured = true
    featured_button_json_response(true)
  end

  def destroy
    @featurable.featured = false
    featured_button_json_response(true)
  end

  private

    def find_featurable
      @featurable = find_polymorphic_object
    end

    def featured_button_json_response(action_result)
      if action_result
        render json: {ok: true, featured: @featurable.featured?}
      else
        render json: {ok: false}, status: :unprocessable_entity
      end
    end
end
