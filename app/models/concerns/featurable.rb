module Featurable
  extend ActiveSupport::Concern

  included do
    def is_featured?
      self.is_featured
    end

    def set_featured
      self.is_featured = true
      self.save
    end

    def unset_featured
      self.is_featured = false
      self.save
    end
  end
end
