class LayersListener

  def map_updated(payload)
    save_layers payload[:map]
  end

  def map_created(payload)
    save_layers payload[:map]
  end

  private

    def save_layers(map)
      map.save_layers_from_attributes if map.layers_attributes
    end
end

