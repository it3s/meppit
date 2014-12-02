class Featured < ActiveRecord::Base
  belongs_to :featurable, polymorphic: true

  validates :featurable, presence: true

  def self.get_by_type(cls)
    # TODO: look for a better solution
    cls.where(id: where(featurable_type: cls).pluck(:featurable_id))
  end
end
