module Authenticable
  extend ActiveSupport::Concern

  included do
    authenticates_with_sorcery! { |config| config.authentications_class = Authentication }

    has_many :authentications, dependent: :destroy
    accepts_nested_attributes_for :authentications
  end
end
