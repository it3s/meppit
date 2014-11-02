module AdminActions
  extend ActiveSupport::Concern

  included do
    before_action :require_admin, only: [:admin]
    before_action :find_flags,    only: [:admin]
  end

  def admin
  end

  protected

    def find_flags
      @unsolved_flags = Flag.includes(:flaggable, :user).unsolved
      @solved_flags = Flag.includes(:flaggable, :user).solved
    end

end


