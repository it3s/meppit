namespace :tags do
  def index_tags(tags)
    tags.each { |tag| Tag.build(tag).save }
  end

  desc "index User interests"
  task :users => :environment do
    User.all.each { |u| index_tags u.interests }
  end

  desc "index GeodData tags"
  task :geo_data => :environment do
    GeodData.all.each { |g| index_tags g.tags }
  end

  desc "index Map tags"
  task :maps => :environment do
    Map.all.each { |m| index_tags m.tags }
  end

  desc "clean all tags"
  task :delete_all => :environment do
    Tag.delete_all
  end

  desc "Index all tags"
  task :all => [:users, :geo_data, :maps]
end
