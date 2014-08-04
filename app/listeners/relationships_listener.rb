class RelationshipsListener

  def geo_data_updated(payload)
    # TODO implement-me
    puts payload[:geo_data].relations_attributes
  end

end

