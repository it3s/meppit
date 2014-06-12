require 'spec_helper'

describe Contributing do
  let(:user) { FactoryGirl.create(:user, name: 'John') }
  let(:geo_data) { FactoryGirl.create :geo_data, name: 'Test object' }
  #let(:map) { FactoryGirl.create :map, name: 'Test map' }

  before { Contributing.delete_all }

  describe "polymorphic contributables" do
    before { Contributing.create contributor: user, contributable: contributable }

    context "a user can contribute to a geo_data" do
      let(:contributable) { geo_data }
      let(:contributing) { Contributing.first }

      it { expect(contributing).to_not be_nil }
      it { expect(contributing.contributor.name).to eq 'John' }
      it { expect(contributing.contributable).to be_a_kind_of GeoData }
      it { expect(contributing.contributable.name).to eq 'Test object' }
    end

    #context "a user can contribute to a map" do
    #  let(:contributable) { map }
    #  let(:contributing) { Contributing.first }
    #
    #  it { expect(contributing).to_not be_nil }
    #  it { expect(contributing.contributor.name).to eq 'John' }
    #  it { expect(contributing.contributable).to be_a_kind_of Map }
    #  it { expect(contributing.contributable.name).to eq 'Test map' }
    #end
  end

  describe "validations" do
    context "#missing_fields? => true" do
      it "validates presence of contributable" do
        c = Contributing.new(contributor: user)
        expect(c.save).to be_false
        expect(c.errors.messages[:contributable].size > 0).to be_true
      end

      it "validates presence of contributor" do
        c = Contributing.new(contributable: geo_data)
        expect(c.save).to be_false
        expect(c.errors.messages[:contributor].size > 0).to be_true
      end
    end

    it "validates unique contributing for same object" do
        Contributing.create(contributor: user, contributable: geo_data)
        expect(Contributing.count).to eq 1
        c = Contributing.new(contributor: user, contributable: geo_data)
        expect(c.save).to be_false
        expect(c.errors.messages[:contributor].first).to eq I18n.t('activerecord.errors.messages.taken')
    end
  end
end
