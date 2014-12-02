module Featurable
  extend ActiveSupport::Concern

  included do
    after_destroy :clean_featured_for_destroyed_featurable!

    def featured?
      Featured.where(_featured_params).exists?
    end

    def featured=(value)
      if value == true
        Featured.find_or_create_by(_featured_params)
      elsif value == false
        featured = Featured.where(_featured_params).first
        featured.destroy if featured
      end
    end

    private

      def _featured_params
        {featurable: self}
      end

      def clean_featured_for_destroyed_featurable!
        Featured.where(_featured_params).destroy_all
      end
  end
end
