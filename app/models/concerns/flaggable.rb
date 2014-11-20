module Flaggable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flaggable

    after_destroy :clean_flags_for_destroyed_flaggable!

    private

      def clean_flags_for_destroyed_flaggable!
        Flag.where(flaggable: self).destroy_all
      end
  end
end

