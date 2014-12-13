desc "Import Data from Mootiro"
task :mootiro_import => :setup_logger do |_, args|
  puts "Import Data from Mootiro"
  MootiroImporter::import()
end


