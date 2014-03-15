require 'spec_helper'

describe Concerns::ContactsHelper do
  let(:user) { FactoryGirl.create :user }
  let(:userWithContacts) { FactoryGirl.create :user, :contacts => {'address' => 'rua Bla', 'phone' => '12345'} }

  describe "#contacts_list_for" do
    it 'returns an empty list for objects with no contacts' do
      expect(contacts_list_for(user)).to eq([])
    end

    it 'selects only the icons forms existing contact keys' do
      expect(helper.contacts_list_for userWithContacts).to eq([
        {:key => 'phone',   :icon => :phone, :value => "12345"},
        {:key => 'address', :icon => :home,  :value => "rua Bla"},
      ])
    end
  end

  describe "#contacts_fields_for" do
    it "builds fields for all contacts" do
      expect(helper.contacts_fields_for(userWithContacts).size).to eq 10
    end

    it "each contact field has key, icon, value and name" do
      expect(helper.contacts_fields_for(userWithContacts).first.keys).to eq [:key, :icon, :value, :name]
    end
  end
end
