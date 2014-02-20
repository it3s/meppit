class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_reader :license_aggrement

  validates :password, :confirmation => true
  validates :password, :presence => true, :on => :create
  validates :email, :name,  :presence => true
  validates :email, :uniqueness => true
  validates :license_aggrement, :acceptance => true

end
