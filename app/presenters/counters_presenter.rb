class CountersPresenter
  include Presenter

  required_keys :object, :ctx

  AVAILABLE_COUNTERS = [:data, :maps, :followers, :contributors]

  def counters
    AVAILABLE_COUNTERS.map { |name|
      OpenStruct.new(counter_options name)
    }.select { |counter|
      object.respond_to? counter[:method]
    }
  end

  def counter_options(name)
    opts = send(:"_#{name}_counter")
    _count = object.try(opts[:method]) || 0
    opts.merge({
      count: _count,
      value: (size == :big) ? ctx.t(opts[:string], count: "<em>#{_count}</em>") : _count
    })
  end

  def size
    @size || :medium
  end

  private

  def counter_url(params)
    begin
      ctx.url_for(params)
    rescue Exception
      "#"
    end
  end

  def _data_counter
    {
      icon:   :'map-marker',
      string: 'counters.data',
      method: :data_count,
      class:  "data-counter",
      url:    counter_url([object, :data])
    }
  end

  def _maps_counter
    {
      icon:   :globe,
      string: 'counters.maps',
      method: :maps_count,
      class:  "maps-counter",
      url:    counter_url([object, :maps])
    }
  end

  def _followers_counter
    {
      icon:   :star,
      string: 'counters.followers',
      method: :followers_count,
      class:  "followers-counter",
      url:    counter_url([object, :followers])
    }
  end

  def _contributors_counter
    {
      icon:   :users,
      string: 'counters.contributors',
      method: :contributors_count,
      class:  "contributors-counter",
      url:    counter_url([object, :contributors])
    }
  end
end
