module MootiroImporter

  module_function

  REDIS_HOST = ENV['MOOTIRO_REDIS_HOST'] || '10.0.2.2'
  REDIS_PORT = ENV['MOOTIRO_REDIS_PORT'] || 6379
  REDIS_PASS = ENV['MOOTIRO_REDIS_PASS'] || ''

  $ok_count = 0
  $failed_count = 0

  _redis_pool = nil
  def redis_pool
    _redis_pool ||= begin
      ConnectionPool.new(size: 5, timeout: 5) do
        Redis.new(host: REDIS_HOST, port: REDIS_PORT, password: REDIS_PASS)
      end
    end
  end

  IMPORT_LIST = ["usr", "org", "com", "res", "ned", "pro", "lay", "cmt", "dis",
                 "rel", "sig", "fil"]
  def should_import?(oid)
    IMPORT_LIST.include?(oid[0...3])
  end

  def import
    while oid = dequeue
      if should_import?(oid)
        print "Importing #{oid}... "
        raw = redis_pool.with { |conn| conn.get("mootiro:#{oid}") }
        data = JSON.parse raw
        send(:"import_#{data['mootiro_type']}", data.with_indifferent_access)
      end
    end
    print "\n"
    print "Success: #{$ok_count}. Failures: #{$failed_count}.\n"
  end

  def dequeue
    redis_pool.with { |conn| conn.lpop('mootiro:migrations') }
  end

  def enqueue_invalid(oid)
    redis_pool.with { |conn| conn.rpush "mootiro:invalid", oid }
  end

  # Here be dragons! black magic all the way
  COORD_REGEX =  /(-?\w+\.?\w+)\s(-?\w+\.?\w+)/
  def wkt_with_reversed_coords(location)
    print "Reversing coords... "
    loc_str = location.to_s
    loc_str.scan(COORD_REGEX).each { |pair|
      loc_str.gsub!("#{pair[0]} #{pair[1]}", "#{pair[1]} #{pair[0]}")
    }
    loc_str
  end

  def remove_geometrycollection(location)
    print "Removing GeometryCollection... "
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

    location
  end

  def parse_geometry(d)
    d[:geometry] ? remove_geometrycollection(wkt_with_reversed_coords(d[:geometry])) : None
  end

  def media_file(field)
    fname = field.split('/').last
    if fname
      path = Rails.root.join('public', 'mootiro_media', fname)
      File.open path
    else
      nil
    end
  end

  def model_from_oid(oid)
    return nil unless oid
    mootiro_oid = MootiroOID.where(oid: oid).first
    mootiro_oid ? mootiro_oid.content : nil
  end

  def default_user
    User.where(name: "IT3S Dev").first
  end

  def build_geo_data(d, &blk)
    importation d[:oid] do

      additional_info = {}
      additional_info.merge! short_description: d[:short_description] unless d[:short_description].blank?
      additional_info.merge! creator: d[:creator] unless d[:creator].blank?

      geo_data = GeoData.new(
        name: d[:name],
        description: d[:description] ? RDiscount.new(d[:description]).to_html : nil,
        created_at: d[:created_at].to_date,
        contacts: (d[:contacts] || {}).compact,
        location: parse_geometry(d),
        tags: d[:tags],
        additional_info: additional_info,
      )
      yield geo_data if blk.present?

      saved = geo_data.save

      MootiroOID.create content: geo_data, oid: d[:oid] if saved
      saved
    end
  end

  def importation(oid, &blk)
    valid = yield
    if valid
      redis_pool.with { |conn| conn.del("mootiro:#{oid}") }
      $ok_count += 1
      print "OK.\n"
    else
      enqueue_invalid(oid)
      print "Failed.\n"
      $failed_count += 1
    end
  end

  def import_user(d)
    importation d[:oid] do
      user = User.new(
        name: d[:name],
        email: d[:email],
        about_me: d[:about_me] ? RDiscount.new(d[:about_me]).to_html : nil,
        crypted_password: d[:crypted_password],
        created_at: d[:created_at].to_date,
        activation_state: d[:is_active] ? 'active' : 'pending',
        contacts: (d[:contacts] || {}).compact,
        location: parse_geometry(d),
        language: d[:language] == 'pt-br' ? 'pt-BR' : d[:language],
      )
      valid = user.valid?(:update)
      if valid
        user.save(validate: false)
        MootiroOID.create content: user, oid: d[:oid]
        user.update_attributes(avatar: media_file(d[:avatar])) unless d[:avatar].blank?
        Admin.create(user: user) if d[:is_admin]
      end
      valid
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
  end

  def import_layer(d)
    importation d[:oid] do

      layer = Layer.new(
        name: d[:name],
        map: model_from_oid(d[:project]),
        position: d[:position],
        visible: d[:visible],
        fill_color: d[:fill_color],
        stroke_color: d[:stroke_color],
        rule: d[:rule],
      )

      saved = layer.save
      MootiroOID.create(content: layer, oid: d[:oid]) if saved

      saved
    end
  end

  def import_comment(d)
    importation d[:oid] do
      comment = Comment.new(
        user: model_from_oid(d[:author]),
        comment: d[:comment],
        created_at: d[:created_at].to_date,
        content: model_from_oid(d[:content_object]),
      )

      saved = comment.save
      MootiroOID.create content: comment, oid: d[:oid] if saved
      saved
    end
  end

  def import_discussion(d)
    import_comment(d)
  end

  def import_relation(d)
    importation d[:oid] do
      model1 = model_from_oid(d[:oid_1])
      model2 = model_from_oid(d[:oid_2])
      return false unless model1 && model2

      relation = Relation.new(
        related_ids:[ model1.id, model2.id ],
        rel_type: d[:rel_type].underscore,
        direction: d[:direction],
        created_at: d[:created_at].to_date,
      )
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
  end

  def import_signature(d)
    importation d[:oid] do
      following = Following.new(
        follower: model_from_oid(d[:user]),
        followable: model_from_oid(d[:content_object]),
      )

      saved = following.save
      MootiroOID.create content: following, oid: d[:oid] if saved
      saved
    end
  end

  def import_file(d)
    importation d[:oid] do
      begin
        picture = Picture.new(
          image: media_file(d[:file]),
          description: d[:subtitle],
          content: model_from_oid(d[:content_object]),
          author: default_user,
        )

        saved = picture.save
        MootiroOID.create content: picture, oid: d[:oid] if saved
      rescue Errno::ENOENT # file does not exist
        print "File not found! "
        saved = false
      end
      saved
    end
  end

  # TODO missing Video (create feature on Meppit first)

  # XXX discard Report and ModelVersioning ?
end
