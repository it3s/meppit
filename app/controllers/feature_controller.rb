class FeatureController < ApplicationController

  before_action :require_admin_role
  before_action :find_featurable

  def create
    feature_button_json_response(@featurable.set_featured)
  end

  def destroy
    feature_button_json_response(@featurable.unset_featured)
  end

  private

    def find_featurable
      @featurable = find_polymorphic_object
    end

    def feature_button_json_response(action_result)
      if action_result
        render json: {ok: true, is_featured: @featurable.is_featured?}
      else
        render json: {ok: false}, status: :unprocessable_entity
      end
    end
end
