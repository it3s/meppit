class Contributing < ActiveRecord::Base
  belongs_to :contributor, class_name: 'User'
  belongs_to :contributable, polymorphic: true

  validates :contributable, presence: true
  validates :contributor,   presence: true
  validates :contributor, uniqueness: {scope: [:contributable_id, :contributable_type]}, unless: :missing_fields?

  def missing_fields?
    contributable.nil? || contributor.nil?
  end
end
