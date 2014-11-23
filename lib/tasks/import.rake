
desc "Import Data from Mootiro"
task :mootiro_import => :environment do
  puts "Import Data from Mootiro"
  MootiroImporter::import()
end


