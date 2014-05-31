namespace :tags do
  def index_tags(tags)
    tags.each { |tag| Tag.build(tag).save }
  end

  desc "index User interests"
  task :user => :environment do
    User.all.each { |u| index_tags u.interests }
  end

  desc "clean all tags"
  task :delete_all => :environment do
    Tag.delete_all
  end

  desc "Index all tags"
  task :all => [:user]
end
