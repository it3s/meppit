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
end
