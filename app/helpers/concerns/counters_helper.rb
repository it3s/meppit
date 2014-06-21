module Concerns
  module CountersHelper
    extend ActiveSupport::Concern

    included do
      def counters_list(obj, only=:all)
        counters = {}
        available_counters = [:data, :maps, :followers, :contributors]
        (only == :all ? available_counters : (only & available_counters)).each do |name|
          counter = send :"_#{name}_counter", obj
          counters[name] = counter if obj.respond_to? counter[:method]
        end
        counters.values()
      end

      private

      def _counter_url(params)
        begin
          url = url_for(params)
        rescue Exception
          url = "#"
        end
        url
      end

      def _data_counter(obj)
        {icon: :'map-marker', string: 'counters.data', method: :data_count, class: "data-counter", url: _counter_url([obj, :data])}
      end

      def _maps_counter(obj)
        {icon: :globe, string: 'counters.maps', method: :maps_count, class: "maps-counter", url: _counter_url([obj, :maps])}
      end

      def _followers_counter(obj)
        {icon: :star, string: 'counters.followers', method: :followers_count, class: "followers-counter", url: _counter_url([obj, :followers])}
      end

      def _contributors_counter(obj)
        {icon: :users, string: 'counters.contributors', method: :contributors_count, class: "contributors-counter", url: _counter_url([obj, :contributors])}
      end

    end
  end
end

