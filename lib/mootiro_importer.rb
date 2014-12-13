module MootiroImporter

  module_function

  REDIS_HOST = ENV['MOOTIRO_REDIS_HOST'] || '10.0.2.2'
  REDIS_PORT = ENV['MOOTIRO_REDIS_PORT'] || 6379
  REDIS_PASS = ENV['MOOTIRO_REDIS_PASS'] || ''

  $ok_count = 0
  $failed_count = 0


# Redis manipulation
# ==================

  _redis_pool = nil
  def redis_pool
    _redis_pool ||= begin
      ConnectionPool.new(size: 5, timeout: 5) do
        Redis.new(host: REDIS_HOST, port: REDIS_PORT, password: REDIS_PASS)
      end
    end
  end

  def dequeue
    redis_pool.with { |conn| conn.lpop('mootiro:migrations') }
  end

  def enqueue_invalid(oid)
    redis_pool.with { |conn| conn.rpush "mootiro:invalid", oid }
  end

  def remove(oid)
    redis_pool.with { |conn| conn.del("mootiro:#{oid}") }
  end


# References
# ==========

  def model_from_oid(oid)
    return nil unless oid
    mootiro_oid = MootiroOID.where(oid: oid).first
    # Don't get unnecessary data to avoid RGeo objects
    mootiro_oid ? mootiro_oid.association(:content).association_scope.select(:id).first : nil
  end

  def default_user
    User.where(name: "IT3S Dev").first
  end


# Importation
# ===========

  IMPORT_LIST = ["usr", "org", "com", "res", "ned", "pro", "lay", "cmt", "dis",
                 "rel", "sig", "fil"]
  def should_import?(oid)
    IMPORT_LIST.include?(oid[0...3])
  end

  def import
    while oid = dequeue
      if should_import?(oid)
        Rails.logger.info "Importing #{oid}... "
        raw = redis_pool.with { |conn| conn.get("mootiro:#{oid}") }
        data = JSON.parse raw
        send(:"import_#{data['mootiro_type']}", data.with_indifferent_access)
      end
    end
    Rails.logger.info "\n"
    Rails.logger.info "Successes: #{$ok_count}. Failures: #{$failed_count}.\n"
  end

  def importation(oid, &blk)
    valid = yield
    if valid
      remove(oid)
      $ok_count += 1
      Rails.logger.info "OK.\n"
    else
      enqueue_invalid(oid)
      Rails.logger.info "Failed.\n"
      $failed_count += 1
    end
  end

  def import_user(d)
    importation d[:oid] do
      build_user d
    end
  end

  def import_organization(d)
    importation d[:oid] do
      build_geo_data d do |geo_data|
        geo_data.additional_info.merge! target_audiences: d[:target_audiences] unless d[:target_audiences].blank?
      end
    end
  end

  def import_community(d)
    importation d[:oid] do
      build_geo_data d do |geo_data|
        geo_data.additional_info.merge! population: d[:population] unless d[:population].blank?
      end
    end
  end

  def import_resource(d)
    importation d[:oid] do
      build_geo_data d
    end
  end

  def import_need(d)
    importation d[:oid] do
      build_geo_data d do |geo_data|
        geo_data.additional_info.merge! target_audiences: d[:target_audiences] unless d[:target_audiences].blank?
      end
    end
  end

  def import_project(d)
    importation d[:oid] do
      build_map d
    end
  end

  def import_layer(d)
    importation d[:oid] do
      build_layer d
    end
  end

  def import_comment(d)
    importation d[:oid] do
      build_comment d
    end
  end

  def import_discussion(d)
    import_comment(d)
  end

  def import_relation(d)
    importation d[:oid] do
      build_relation d
    end
  end

  def import_signature(d)
    importation d[:oid] do
      build_following d
    end
  end

  def import_file(d)
    importation d[:oid] do
      build_picture d
    end
  end


# Builders
# ========

  def build_user(d, &blk)
    Rails.logger.debug "Building User... "
    user = User.new(
      name: d[:name],
      email: d[:email],
      about_me: d[:about_me] ? RDiscount.new(d[:about_me]).to_html : nil,
      crypted_password: d[:crypted_password],
      created_at: d[:created_at].to_date,
      activation_state: d[:is_active] ? 'active' : 'pending',
      contacts: (d[:contacts] || {}).compact,
      language: d[:language] == 'pt-br' ? 'pt-BR' : d[:language],
    )
    valid = user.valid?(:update)
    if valid
      yield user if blk.present?

      user.save(validate: false)
      MootiroOID.create content: user, oid: d[:oid]
      user.update_attributes(avatar: media_file(d[:avatar])) unless d[:avatar].blank?

      Rails.logger.debug "Adding Location Data... "
      # Save WKT directly to avoid RGeo objects
      user.update_columns(location: parse_geometry(d))
      Rails.logger.debug "Flipping Coordinates... "
      # Flip coordinates
      ActiveRecord::Base.connection.execute("UPDATE users SET location = ST_FlipCoordinates(location) WHERE users.id=#{user.id};")

      Admin.create(user: user) if d[:is_admin]
    end
    valid
  end

  def build_geo_data(d, &blk)
    Rails.logger.debug "Building GeoData... "
    additional_info = {}
    additional_info.merge! short_description: d[:short_description] unless d[:short_description].blank?
    additional_info.merge! creator: d[:creator] unless d[:creator].blank?

    geo_data = GeoData.new(
      name: d[:name],
      description: d[:description] ? RDiscount.new(d[:description]).to_html : nil,
      created_at: d[:created_at].to_date,
      contacts: (d[:contacts] || {}).compact,
      tags: d[:tags],
      additional_info: additional_info,
    )
    yield geo_data if blk.present?

    saved = geo_data.save

    Rails.logger.debug "Adding Location Data... "
    # Save WKT directly to avoid RGeo objects
    geo_data.update_columns(location: parse_geometry(d))
    Rails.logger.debug "Flipping Coordinates... "
    # Flip coordinates
    ActiveRecord::Base.connection.execute("UPDATE geo_data SET location = ST_FlipCoordinates(location) WHERE geo_data.id=#{geo_data.id};")

    MootiroOID.create content: geo_data, oid: d[:oid] if saved
    saved
  end

  def build_map(d, &blk)
    Rails.logger.debug "Building Map... "
    additional_info = {}
    additional_info.merge! short_description: d[:short_description] unless d[:short_description].blank?

    map = Map.new(
      name: d[:name],
      description: d[:description] ? RDiscount.new(d[:description]).to_html : nil,
      created_at: d[:created_at].to_date,
      contacts: (d[:contacts] || {}).compact,
      administrator: d[:creator] ? model_from_oid(d[:creator]) : default_user,
      tags: d[:tags],
      additional_info: additional_info,
      migrated_info: {
        maptype: d[:maptype],
        bbox: d[:bbox],
        custom_bbox: d[:custom_bbox],
        logo: d[:logo],
        partners_logo: d[:partners_logo],
      }

    )
    yield map if blk.present?

    saved = map.save

    if saved
      MootiroOID.create(content: map, oid: d[:oid])

      d[:contributors].each do |c|
        contributor = model_from_oid(c)
        Contributing.create(contributor: contributor, contributable: map) if contributor
      end

      d[:related_items].each do |oid|
        item = model_from_oid(oid)
        Mapping.create(geo_data: item, map: map) if item
      end
    end

    saved
  end

  def build_following(d, &blk)
    Rails.logger.debug "Building Following... "
    following = Following.new(
      follower: model_from_oid(d[:user]),
      followable: model_from_oid(d[:content_object]),
    )
    yield following if blk.present?

    saved = following.save
    MootiroOID.create content: following, oid: d[:oid] if saved
    saved
  end

  def build_picture(d, &blk)
    Rails.logger.debug "Building Picture... "
    begin
      picture = Picture.new(
        image: media_file(d[:file]),
        description: d[:subtitle],
        content: model_from_oid(d[:content_object]),
        author: default_user,
      )
      yield picture if blk.present?

      saved = picture.save
      MootiroOID.create content: picture, oid: d[:oid] if saved
    rescue Errno::ENOENT # file does not exist
      Rails.logger.info "File not found! (#{d[:file]}) "
      saved = false
    end
    saved
  end

  def build_relation(d, &blk)
    Rails.logger.debug "Building Relation... "
    model1 = model_from_oid(d[:oid_1])
    model2 = model_from_oid(d[:oid_2])
    return false unless model1 && model2

    relation = Relation.new(
      related_ids:[ model1.id, model2.id ],
      rel_type: d[:rel_type].underscore,
      direction: d[:direction],
      created_at: d[:created_at].to_date,
    )
    yield relation if blk.present?

    saved = relation.save

    if saved
      MootiroOID.create content: relation, oid: d[:oid]

      m = d[:metadata]
      RelationMetadata.create(
        relation:    relation,
        description: m['description'],
        start_date:  m['start_date'].try(:to_date),
        end_date:    m['end_date'].try(:to_date),
        created_at:  d['created_at'].to_date,
        currency:    m['currency'].try(:downcase),
        amount:      m['value'],
      )
    end

    saved
  end

  def build_layer(d, &blk)
    Rails.logger.debug "Building Layer... "
    layer = Layer.new(
      name: d[:name],
      map: model_from_oid(d[:project]),
      position: d[:position],
      visible: d[:visible],
      fill_color: d[:fill_color],
      stroke_color: d[:stroke_color],
      rule: d[:rule],
    )
    yield layer if blk.present?

    saved = layer.save
    MootiroOID.create(content: layer, oid: d[:oid]) if saved

    saved
  end

  def build_comment(d, &blk)
    Rails.logger.debug "Building Comment... "
    comment = Comment.new(
      user: model_from_oid(d[:author]),
      comment: d[:comment],
      created_at: d[:created_at].to_date,
      content: model_from_oid(d[:content_object]),
    )
    yield comment if blk.present?

    saved = comment.save
    MootiroOID.create content: comment, oid: d[:oid] if saved
    saved
  end


# Utils
# =====

  # DEPRECATED: Using PostGIS ST_FlipCoordinates instead.
  # Here be dragons! black magic all the way
  COORD_REGEX =  /(-?\w+\.?\w+)\s(-?\w+\.?\w+)/
  def wkt_with_reversed_coords(location)
    Rails.logger.debug "Reversing coords... "
    return location.gsub(COORD_REGEX, '\2 \1')
    #loc_str = location.to_s
    #loc_str.scan(COORD_REGEX).each { |pair|
    #  loc_str.gsub!("#{pair[0]} #{pair[1]}", "#{pair[1]} #{pair[0]}")
    #}
    #loc_str
  end

  # DEPRECATED: Already getting the correct geometry type.
  def remove_geometrycollection(location)
    Rails.logger.debug "Removing GeometryCollection... "
    return nil if location.eql? 'EMPTY GEOMETRYCOLLECTION'
    return location unless location.include? "GEOMETRYCOLLECTION"

    factory = RGeo::Geographic.spherical_factory :srid => 4326
    geom = factory.parse_wkt location
    return nil if geom.nil?
    return geom[0].as_text unless geom.size != 1

    points   = []
    polygons = []
    lines    = []
    others   = []
    geom.each { |g|
      case g.geometry_type
      when RGeo::Feature::Point
        points.push g
      when RGeo::Feature::Polygon
        polygons.push g
      when RGeo::Feature::LineString
        lines.push g
      else
        others.push g
      end
    }

    # TODO: what should we do when there is more than one type of geometry or
    # an untreated type of geometry?

    return factory.multi_polygon(polygons).as_text  if polygons.size > 0
    return factory.multi_line_string(lines).as_text if lines.size > 0
    return factory.multi_point(points).as_text      if points.size > 0

    Rails.logger.debug "Could not remove... "
    location
  end

  def parse_geometry(d)
    d[:geometry] ? "SRID=4326;#{d[:geometry]}" : None
  end

  def media_file(field)
    Rails.logger.debug "Getting Media File... "
    fname = field.split('/').last
    if fname
      path = Rails.root.join('public', 'mootiro_media', fname)
      File.open path
    else
      nil
    end
  end


  # TODO missing Video (create feature on Meppit first)
  # TODO list fails

  # XXX discard Report and ModelVersioning ?
end
