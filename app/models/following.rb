class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followable, polymorphic: true

  validates :followable, presence: true
  validates :follower,   presence: true
  validates :follower,   uniqueness: {scope: [:followable_id, :followable_type]}, unless: :missing_fields?

  validate :user_cant_follow_himself

  def missing_fields?
    followable.nil? || follower.nil?
  end

  def user_cant_follow_himself
    if followable_type == 'User' && followable_id == follower_id
      errors.add :followable, I18n.t('errors.messages.follow_himself')
    end
  end
end
