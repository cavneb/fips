require File.expand_path('../../fips/import_service', __FILE__)

desc "Import all data"
task :import_data => :environment do
  import_service = Fips::ImportService.new
  import_service.import_all
end

desc "Import zip codes"
task :import_zip_codes => :environment do
  import_service = Fips::ImportService.new
  import_service.import_zip_codes
end

desc "Import fips"
task :import_fips => :environment do
  import_service = Fips::ImportService.new
  import_service.import_fips
end
