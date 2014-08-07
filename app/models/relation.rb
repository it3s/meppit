class Relation < ActiveRecord::Base
  has_one :metadata, class_name: 'RelationMetadata'

  validates :related_ids, :rel_type, :direction, presence: true

  validate :related_ids_size_eq_two
  validate :direction_is_dir_or_rev
  validate :rel_type_from_accepted_types_list

  scope :find_related, -> (_id) { where 'related_ids @> ARRAY[?]', _id.to_s }

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

  def self.options
    RELATION_TYPES.map { |key| [
      [translated("#{key}_dir").humanize, "#{key}_dir"],
      [translated("#{key}_rev").humanize, "#{key}_rev"],
    ] }.flatten(1)
  end

  def upsert_metadata(metadata_struct)
    build_metadata if metadata.nil?
    metadata.assign_attributes metadata_struct.to_h
    metadata.save
  end

  private

  def self.translated(key_with_direction)
    I18n.t("relations.types.#{key_with_direction}")
  end

  def related_ids_size_eq_two
    errors.add(:related_ids, I18n.t('relations.invalid.related_ids_size')) unless related_ids.try(:size) == 2
  end

  def direction_is_dir_or_rev
    errors.add :direction, I18n.t('relations.invalid.direction') unless [:dir, :rev].include? direction.try(:to_sym)
  end

  def rel_type_from_accepted_types_list
    errors.add :rel_type, I18n.t('relations.invalid.type') unless RELATION_TYPES.include? rel_type.try(:to_sym)
  end
end
