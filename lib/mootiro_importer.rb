module MootiroImporter

  module_function

  REDIS_HOST = ENV['MOOTIRO_REDIS_HOST'] || '10.0.2.2'
  REDIS_PORT = ENV['MOOTIRO_REDIS_PORT'] || 6379
  REDIS_PASS = ENV['MOOTIRO_REDIS_PASS'] || ''

  _redis = nil
  def redis
    _redis ||= Redis.new(host: REDIS_HOST, port: REDIS_PORT) # , password: REDIS_PASS)
  end

  IMPORT_LIST = ["usr", "org", "com", "res", "ned", "cmt", "dis"]
  def should_import?(oid)
    IMPORT_LIST.include?(oid[0...3])
  end

  def import
    while oid = dequeue
      if should_import?(oid)
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
    oid ? MootiroOID.where(oid).first.content : nil
  end

  def build_geo_data(d, &blk)
    importation d[:oid] do

      additional_info = {}
      additional_info.merge! short_description: RDiscount.new(d[:short_description]).to_html unless d[:short_description].blank?
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

  #==============================================================
  # depends on others

  # def import_comment(d)
  #   importation d[:oid] do
  #     comment = Comment.new(
  #       user: model_from_oid(d[:author]),
  #       comment: d[:comment],
  #       created_at: d[:created_at].to_date,
  #       content: model_from_oid(d[:content_object]),
  #     )

  #     saved = comment.save
  #     MootiroOID.create content: comment, oid: d[:oid] if saved
  #     saved
  #   end
  # end

  # def import_discussion(d)
  #   import_comment(d)
  # end
end
