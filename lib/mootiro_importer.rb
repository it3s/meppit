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
      if oid.include?("usr_")
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
        location: d[:geometry],
        avatar: (d[:avatar] || '').split('/').last,
        language: d[:language] == 'pt-br' ? 'pt-BR' : d[:language],
      )
      valid = user.valid?(:update)
      if valid
        r = user.save(validate: false)
        Admin.create(user: user) if d[:is_admin]
      end
      valid
    end
  end

end
