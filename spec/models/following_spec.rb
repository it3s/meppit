require 'spec_helper'

describe Following do
  let(:user) { FactoryGirl.create(:user, name: 'John') }
  let(:other_user) { FactoryGirl.create(:user, name: 'Jane') }
  let(:geo_data) { FactoryGirl.create :geo_data, name: 'Test object' }

  before { Following.delete_all }

  describe "polymorphic followables" do
    before { Following.create follower: user, followable: followable }

    context "a user can follow an object" do
      let(:followable) { geo_data }
      let(:following) { Following.first }

      it { expect(following).to_not be_nil }
      it { expect(following.follower.name).to eq 'John' }
      it { expect(following.followable).to be_a_kind_of GeoData }
      it { expect(following.followable.name).to eq 'Test object' }
    end

    context "a user can follow an object" do
      let(:followable) { other_user }
      let(:following) { Following.first }

      it { expect(following).to_not be_nil }
      it { expect(following.follower.name).to eq 'John' }
      it { expect(following.followable).to be_a_kind_of User }
      it { expect(following.followable.name).to eq 'Jane' }
    end
  end

  describe "validations" do
    context "#missing_fields? => true" do

      it "validates presence of followable" do
        f = Following.new(follower: user)
        expect(f.save).to be_false
        expect(f.errors.messages[:followable].size > 0).to be_true
      end

      it "validates presence of follower" do
        f = Following.new(followable: other_user)
        expect(f.save).to be_false
        expect(f.errors.messages[:follower].size > 0).to be_true
      end
    end

    context "#missing_fields? => true" do
      it "validates unique following for same object" do
          Following.create(follower: user, followable: geo_data)
          expect(Following.count).to eq 1
          f = Following.new(follower: user, followable: geo_data)
          expect(f.save).to be_false
          expect(f.errors.messages[:follower].first).to eq  I18n.t('activerecord.errors.messages.taken')
      end
    end
  end
end
