module MootiroImporter

  module_function

  REDIS_HOST = ENV['MOOTIRO_REDIS_HOST'] || '10.0.2.2'
  REDIS_PORT = ENV['MOOTIRO_REDIS_PORT'] || 6379
  REDIS_PASS = ENV['MOOTIRO_REDIS_PASS'] || ''

  _redis = nil
  def redis
    _redis ||= Redis.new(host: REDIS_HOST, port: REDIS_PORT) # , password: REDIS_PASS)
  end

  def import
    while oid = dequeue
      if ["usr", "org"].include?(oid[0...3])
        data = JSON.parse redis.get("mootiro:#{oid}")
        send(:"import_#{data['mootiro_type']}", data.with_indifferent_access)
      end
    end
  end

  def dequeue
    redis.lpop('mootiro:migrations')
  end

  def enqueue_invalid(oid)
    redis.rpush "mootiro:invalid", oid
  end

  # Here be dragons! black magic all the way
  COORD_REGEX =  /(-?\w+\.?\w+)\s(-?\w+\.?\w+)/
  def wkt_with_reversed_coords(location)
    loc_str = location.to_s
    loc_str.scan(COORD_REGEX).each { |pair|
      loc_str.gsub!("#{pair[0]} #{pair[1]}", "#{pair[1]} #{pair[0]}")
    }
    loc_str
  end

  def parse_geometry(d)
    d[:geometry] ? wkt_with_reversed_coords(d[:geometry]) : None
  end

  def importation(oid, &blk)
    valid = yield
    valid ? redis.del("mootiro:#{oid}") : enqueue_invalid(oid)
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
        # avatar: (d[:avatar] || '').split('/').last,
        language: d[:language] == 'pt-br' ? 'pt-BR' : d[:language],
      )
      valid = user.valid?(:update)
      if valid
        # TODO figure out how to do Avatar migration
        user.save(validate: false)
        MootiroOID.create content: user, oid: d[:oid]
        Admin.create(user: user) if d[:is_admin]
      end
      valid
    end
  end

  def import_organization(d)
    importation d[:oid] do

      additional_info = {}
      additional_info.merge! d[:target_audiences] unless d[:target_audiences].blank?
      additional_info.merge! RDiscount.new(d[:short_description]).to_html unless d[:short_description].blank?
      additional_info.merge! d[:creator] unless d[:creator].blank?

      geo_data = GeoData.new(
        name: d[:name],
        description: d[:description] ? RDiscount.new(d[:description]).to_html : nil,
        created_at: d[:created_at].to_date,
        contacts: (d[:contacts] || {}).compact,
        location: parse_geometry(d),
        tags: d[:tags],
        additional_info: additional_info,
      )
      saved = geo_data.save
      MootiroOID.create content: geo_data, oid: d[:oid] if saved
      saved
    end
  end

end
