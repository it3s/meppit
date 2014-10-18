module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :content, dependent: :destroy
  end
end
