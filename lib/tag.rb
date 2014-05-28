class Tag
  include ActiveModel::Model

  attr_accessor :tag

  def initialize(tag)
    @tag = tag
  end

  def index
    # TODO implement-me
  end
end
