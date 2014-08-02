module Relations
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    RELATION_TYPES = [
      :ownership,
      :participation,
      :partnership,
      :grants,
      :certification,
      :attendance,
      :directing_people,
      :volunteers,
      :support,
      :representation,
      :membership,
      :supply,
      :council,
      :contains,
      :investment,
    ]

    def relations_options
      RELATION_TYPES.map { |key| [
        [translated_relation("#{key}_dir").humanize, "#{key}_dir"],
        [translated_relation("#{key}_rev").humanize, "#{key}_rev"],
      ] }.flatten(1)
    end

    private

    def translated_relation(key_with_direction)
      I18n.t("relations.types.#{key_with_direction}")
    end
  end
end
