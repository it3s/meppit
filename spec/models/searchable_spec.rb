require 'spec_helper'

describe Searchable do
  before do
    FactoryGirl.create :user,     name: "Awesome user"
    FactoryGirl.create :user,     name: "Dumb user"
    FactoryGirl.create :user,     name: "kid user",        about_me:    "Mommy says I'm great"
    FactoryGirl.create :geo_data, name: "Awesome org",     description: "one of the greatest organizations, ever!"
    FactoryGirl.create :map,      name: "Non-awesome map", description: "dumb people by region"
  end

  def search_for(term)
    PgSearch.multisearch(term).map { |d| d.searchable.name }
  end

  it "search on different models by name" do
    expect(search_for "awes").to eq ["Awesome user", "Awesome org", "Non-awesome map"]
  end

  it "search on different models by description" do
    expect(search_for "great").to eq ["kid user", "Awesome org"]
  end

  it "search across diferent field and diferent models" do
    expect(search_for "dumb").to eq ["Dumb user", "Non-awesome map"]
  end

end
