module Concerns
  module ContactsHelper
    extend ActiveSupport::Concern

    included do
      CONTACTS_ICONS = {
        :phone       => :phone,
        :address     => :home,
        :city        => :road,
        :compl       => :paperclip,
        :site        => :laptop,
        :email       => :envelope,
        :twitter     => :twitter,
        :facebook    => :facebook,
        :other       => :compass,
        :postal_code => :'envelope-o'
      }.with_indifferent_access
    end

    def contacts_list_for(object)
      CONTACTS_ICONS.select{|key, val| object.contacts.keys.include? key }.map{ |key, icon| {
        :key => key, :icon => icon, :value => object.contacts[key]
      }}
    end

    def contacts_fields_for(object)
      CONTACTS_ICONS.map{ |key, icon| {
        :key   => key,
        :icon  => icon,
        :value => object.contacts[key],
        :name  => "#{object.class.name.downcase}[contacts][#{key}]",
      }}
    end
  end
end
