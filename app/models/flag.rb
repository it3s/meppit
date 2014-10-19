class Flag < ActiveRecord::Base
  belongs_to :user

  validates :user, :reason, presence: true
  validate  :reason_from_list

  scope :solved,   -> { where(solved: true)  }
  scope :unsolved, -> { where(solved: false) }

  def self.reason_choices
    {
      'deletion'      => 'Request for Deletion',
      'spam'          => 'Spam',
      'inappropriate' => 'Inappropriate',
      'tos_violation' => 'Terms of Service Violation',
      'copyright'     => 'Copyright Violation',
      'wronf_info'    => 'Wrong Information',
      'other'         => 'Other'
    }
  end

  private

    def reason_from_list
      errors.add :reason, 'Invalid reason' if reason && !self.class.reason_choices.keys.include?(reason)
    end
end
