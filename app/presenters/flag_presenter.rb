class FlagPresenter
  include Presenter

  required_keys :flag, :ctx

  def target
    flag.flaggable
  end

  def name
    target.name
  end

  def type
    flag.solved ? 'solved' : 'unsolved'
  end
end
