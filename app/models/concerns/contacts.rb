module Contacts
  extend ActiveSupport::Concern

  included do
    store_accessor :contacts
  end

end
