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
    opts.merge!({ url: counter_url(opts[:url_params]) }) if object.respond_to? opts[:method]
    opts.merge({
      count: _count,
      classname: "#{opts[:classname]} #{size_}",
      value: (size_ == :big) ? ctx.t(opts[:string], count: "<em class=\"counter-label\">#{_count}</em>") : "<span class=\"counter-label\">#{_count}</span>"
    })
  end

  def size_
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
      icon:       :'map-marker',
      string:     'counters.data',
      method:     :data_count,
      classname:  "data-counter",
      url_params: [:geo_data, object]
    }
  end

  def _maps_counter
    {
      icon:       :globe,
      string:     'counters.maps',
      method:     :maps_count,
      classname:  "maps-counter",
      url_params: [:maps, object],
      component:  _component_for('maps')
    }
  end

  def _followers_counter
    {
      icon:       :star,
      string:     'counters.followers',
      method:     :followers_count,
      classname:  "followers-counter",
      url_params: [object, :followers],
      component:  _component_for('followers')
    }
  end

  def _contributors_counter
    {
      icon:       :users,
      string:     'counters.contributors',
      method:     :contributors_count,
      classname:  "contributors-counter",
      url_params: [object, :contributors]
    }
  end

  def _component_for(type)
    opts_json = {type: type, id: ctx.identifier_for(object)}.to_json
    {
      :type => "counter",
      :opts => "data-counter=#{ opts_json } "
    }
  end
end
