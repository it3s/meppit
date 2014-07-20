require 'spec_helper'

describe Tag do
  let!(:tag) { Tag.create tag: 'Cool Tag' }

  it { expect(subject).to have_db_column(:tag) }

  it 'downcases tags before saving' do
    expect(tag.tag).to eql 'cool tag'
  end

  it 'validates uniqueness' do
    tag2 = Tag.new tag: 'cool tag'
    expect(tag2.save).to eq false
    expect(tag2.errors.messages[:tag].first).to eq I18n.t('activerecord.errors.messages.taken')
  end

  describe ".build" do
    it "builds downcased instace" do
      tag = Tag.build 'Ruby on Rails'
      expect(tag.tag).to eq 'ruby on rails'
      expect(tag).to be_a_kind_of Tag
    end
  end

  describe ".search" do
    before do
      ['ruby', 'rugby', 'ruby on rails', 'bla', 'rails'].each { |tg| Tag.create tag: tg }
    end

    it { expect(Tag.search('ru'  ).map(&:tag)).to eq ['ruby', 'rugby', 'ruby on rails'] }
    it { expect(Tag.search('ruby').map(&:tag)).to eq ['ruby', 'ruby on rails', 'rugby'] }
    it { expect(Tag.search('rubi').map(&:tag)).to eq ['ruby', 'rugby', 'ruby on rails'] }
  end
end
