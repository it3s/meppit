class Flag < ActiveRecord::Base
  belongs_to :user

  validates :user, :reason, presence: true
  validate  :reason_from_list

  scope :solved,   -> { where(solved: true)  }
  scope :unsolved, -> { where(solved: false) }

  def self.reason_choices
    @reasons_ ||= [
      'deletion'      ,  # 'Request for Deletion',
      'spam'          ,  # 'Spam',
      'inappropriate' ,  # 'Inappropriate',
      'tos_violation' ,  # 'Terms of Service Violation',
      'copyright'     ,  # 'Copyright Violation',
      'wrong_info'    ,  # 'Wrong Information',
      'other'         ,  # 'Other'
    ]
  end

  def reason_choices
    self.class.reason_choices
  end

  private

    def reason_from_list
      errors.add :reason, 'Invalid reason' if reason && !reason_choices.include?(reason)
    end
end
