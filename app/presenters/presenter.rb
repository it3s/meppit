module Presenter
  extend ActiveSupport::Concern

  def initialize(hash)
    (try(:required_keys) || []).each { |k| raise "Required key: #{k}" unless hash.keys.include? k }

    hash.each do |k,v|
      # create and initialize an instance variable for this key/value pair
      self.instance_variable_set("@#{k}", v)

      # create the getter that returns the instance variable
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})

      # create the setter that sets the instance variable
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  module ClassMethods
    def required_keys(*keys)
      define_method "required_keys" do
        keys
      end
    end
  end
end
