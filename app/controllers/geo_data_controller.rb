class GeoDataController < ObjectsController
  before_action :require_login, except: [:index, :show, :maps, :search_by_name]
  before_action :find_object,   except: [:index, :new, :create, :search_by_name, :bulk_add_map]


  def maps
    @maps = paginate @geo_data.maps
    render layout: nil if request.xhr?
  end

  def add_map
    add_mapping_to Map
  end

  def bulk_add_map
    msg, status = (map =  find_map) ? bulk_add(map) : invalid_map
    render json: {flash: flash_xhr(msg)}, status: status
  end

  private

  def find_map
    Map.find_by(id: params[:map])
  end

  def bulk_add(map)
    geo_data_ids = params.fetch(:geo_data_ids, '').split(',')
    if geo_data_ids.empty?
      [t('geo_data.bulk_add_map.empty_selection'), :unprocessable_entity]
    else
      geo_data_ids.each { |_id| map.mappings.create geo_data_id: _id }
      [t('geo_data.bulk_add_map.added', count: geo_data_ids.count, name: map.name), :ok]
    end
  end

  def invalid_map
    [t("geo_data.add_map.invalid"), :unprocessable_entity]
  end

end
