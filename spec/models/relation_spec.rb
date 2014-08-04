require 'spec_helper'

describe Relation do
  it { expect(subject).to have_db_column :related_ids }
  it { expect(subject).to have_db_column :rel_type }
  it { expect(subject).to have_db_column :direction }
  it { expect(subject).to validate_presence_of :related_ids }
  it { expect(subject).to validate_presence_of :rel_type }
  it { expect(subject).to validate_presence_of :direction }
  it { expect(subject).to have_db_index(:related_ids) }

  describe "validate related_ids size" do
    let(:relation) { Relation.new related_ids: related_ids, rel_type: 'partnership', direction: 'dir' }

    context "empty" do
      let(:related_ids) { [] }

      it "returns error" do
        expect(relation.valid?).to eq false
        expect(relation.errors[:related_ids][1]).to eq I18n.t('relations.invalid_related_ids_size')
      end
    end
    context "one id" do
      let(:related_ids) { [1] }

      it "returns error" do
        expect(relation.valid?).to eq false
        expect(relation.errors[:related_ids]).to eq [I18n.t('relations.invalid_related_ids_size')]
      end
    end
    context "more than 2 ids" do
      let(:related_ids) { [1, 2, 3] }

      it "returns error" do
        expect(relation.valid?).to eq false
        expect(relation.errors[:related_ids]).to eq [I18n.t('relations.invalid_related_ids_size')]
      end
    end
    context "2 ids" do
      let(:related_ids) { [1, 2] }
      it { expect(relation.valid?).to eq true }
    end
  end

  describe "validate direction" do
    let(:relation) { Relation.new related_ids: [1,2], rel_type: 'partnership', direction: direction }

    context "anyone besides dir or rev" do
      let(:direction) { :anyone }

      it "returns error" do
        expect(relation.valid?).to eq false
        expect(relation.errors[:direction]).to eq [I18n.t('relations.invalid_direction')]
      end
    end
    context "dir as symbol" do
      let(:direction) { :dir }
      it { expect(relation.valid?).to eq true }
    end
    context "dir as string" do
      let(:direction) { "dir" }
      it { expect(relation.valid?).to eq true }
    end
    context "rev as symbol" do
      let(:direction) { :rev }
      it { expect(relation.valid?).to eq true }
    end
    context "rev as string" do
      let(:direction) { "rev" }
      it { expect(relation.valid?).to eq true }
    end
  end

  describe "validate rel_type" do
    let(:relation) { Relation.new related_ids: [1,2], rel_type: rel_type, direction: 'dir' }

    context "valid type (as symbol)" do
      let(:rel_type) { :ownership }
      it { expect(relation.valid?).to eq true }
    end
    context "valid type (as string)" do
      let(:rel_type) { "ownership" }
      it { expect(relation.valid?).to eq true }
    end
    context "invalid type" do
      let(:rel_type) { 'blablabla' }

      it "returns error" do
        expect(relation.valid?).to eq false
        expect(relation.errors[:rel_type]).to eq [I18n.t('relations.invalid_type')]
      end
    end
  end

  describe "add relation" do
    let(:obj1) { FactoryGirl.create :geo_data }
    let(:obj2) { FactoryGirl.create :geo_data }

    it "add the related objects ids on an array" do
      relation = Relation.new related_ids: [obj1.id, obj2.id], rel_type: 'partnership', direction: 'dir'
      expect(relation.save).to eq true
      expect(relation.id).to_not be nil
    end
  end

  describe ".find_related" do
    let(:obj1) { FactoryGirl.create :geo_data }
    let(:obj2) { FactoryGirl.create :geo_data }
    let(:obj3) { FactoryGirl.create :geo_data }

    before {
      Relation.create related_ids: [obj1.id, obj2.id], rel_type: 'partnership', direction: 'dir'
      Relation.create related_ids: [obj2.id, obj3.id], rel_type: 'partnership', direction: 'dir'
    }

    it "finds the relations with the id on the first position" do
      result = Relation.find_related obj1.id
      expect(result.count).to eq 1
      expect(result.first.related_ids).to eq [obj1.id, obj2.id].map &:to_s
    end
    it "finds the relations with the id in any position" do
      result = Relation.find_related obj2.id
      expect(result.count).to eq 2
      expect(result.first.related_ids ).to eq [obj1.id, obj2.id].map &:to_s
      expect(result.second.related_ids).to eq [obj2.id, obj3.id].map &:to_s
    end
  end
end
