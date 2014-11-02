module AdminActions
  extend ActiveSupport::Concern

  included do
    before_action :is_admin,   only: [:admin]
    before_action :find_flags, only: [:admin]
  end

  def admin
  end

  protected

    def is_admin
      redirect_to(root_path, notice: t('access_denied')) unless current_user.admin?
    end

    def find_flags
      @unsolved_flags = Flag.includes(:flaggable).unsolved
      @solved_flags = Flag.includes(:flaggable).solved
    end

end


