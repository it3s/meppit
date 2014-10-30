class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :flaggable, polymorphic: true

  validates :user, :reason, :flaggable, presence: true
  validate  :reason_from_list

  scope :solved,   -> { where(solved: true)  }
  scope :unsolved, -> { where(solved: false) }

  def self.reason_choices
    @reasons_ ||= [
      'deletion',
      'spam',
      'inappropriate',
      'tos_violation',
      'copyright',
      'wrong_info',
      'other',
    ]
  end

  private

    def reason_from_list
      errors.add :reason, 'Invalid reason' if reason && !self.class.reason_choices.include?(reason)
    end
end
