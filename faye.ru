require 'yaml'
require 'faye'

FAYE_TOKEN = YAML.load_file("config/application.yml")['FAYE_TOKEN']

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message.fetch('ext', {})['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
faye_server.add_extension(ServerAuth.new)
run faye_server
