class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followable, polymorphic: true

  validates :followable, presence: true
  validates :follower,   presence: true
  validates :follower,   uniqueness: {scope: [:followable_id, :followable_type]}, unless: :missing_fields?

  def missing_fields?
    followable.nil? || follower.nil?
  end
end
