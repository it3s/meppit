module FayeClient

  module_function

  def publish(channel, data)
    message = { channel: channel, data: data, ext: {auth_token: ENV['FAYE_TOKEN']} }
    uri = URI.parse(ENV['FAYE_URL'])
    begin
      Net::HTTP.post_form(uri, message: message.to_json)
    rescue
      ::Rails.logger.error 'Error trying to send message to Faye'
    end
  end
end
