class RelationshipsListener

  def geo_data_updated(payload)
    geo_data = payload[:geo_data]
    geo_data.save_relations_from_attributes if geo_data.relations_attributes
  end

end

