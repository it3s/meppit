class RelationshipsListener

  def geo_data_updated(payload)
    save_relation payload[:geo_data]
  end

  def geo_data_created(payload)
    save_relation payload[:geo_data]
  end

  private

    def save_relation(geo_data)
      geo_data.save_relations_from_attributes if geo_data.relations_attributes
    end
end

