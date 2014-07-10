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
    return unless object.respond_to? opts[:method]
    _count = object.try(opts[:method]) || 0
    opts.merge({
      count: _count,
      url: counter_url(opts[:url_params]),
      value: (size == :big) ? ctx.t(opts[:string], count: "<em class=\"counter-label\">#{_count}</em>") : "<span class=\"counter-label\">#{_count}</span>"
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
      ctx.url_for(params.reverse)
    end
  end

  def _data_counter
    {
      icon:   :'map-marker',
      string: 'counters.data',
      method: :data_count,
      class:  "data-counter",
      url_params: [:geo_data, object]
    }
  end

  def _maps_counter
    {
      icon:   :globe,
      string: 'counters.maps',
      method: :maps_count,
      class:  "maps-counter",
      url_params: [:maps, object]
    }
  end

  def _followers_counter
    {
      icon:   :star,
      string: 'counters.followers',
      method: :followers_count,
      class:  "followers-counter",
      url_params: [object, :followers],
      component: _followers_component
    }
  end

  def _contributors_counter
    {
      icon:   :users,
      string: 'counters.contributors',
      method: :contributors_count,
      class:  "contributors-counter",
      url_params: [object, :contributors]
    }
  end

  def _followers_component
    opts_json = {type: 'followers', id: ctx.identifier_for(object)}.to_json
    {
      :type => "counter",
      :opts => "data-counter=#{ opts_json } "
    }
  end
end
