require 'csv'
require 'ruby-progressbar'
require 'nokogiri'
require 'open-uri'

module Fips
  class ImportService

    def import_all
      import_zip_codes
      import_fips
    end

    def import_zip_codes
      ZipCode.delete_all

      zip_codes_file = File.expand_path('../../../data/zip_code_database.csv', __FILE__)

      # initialize progress bar for console logging
      row_count = File.foreach(zip_codes_file).inject(0) {|c, line| c+1}
      progress_bar = ProgressBar.create(
          title: 'Zip Codes',
          starting_at: 1,
          total: row_count + 20, # buffer
          format: '%a |%b>>%i| %p%% %t'
      )

      CSV.foreach(zip_codes_file) do |row|
        next if $. == 0

        zip_code = ZipCode.new
        zip_code.zip                  = row[0]
        zip_code.zip_type             = row[1]
        zip_code.primary_city         = row[2]
        zip_code.acceptable_cities    = row[3]
        zip_code.unacceptable_cities  = row[4]
        zip_code.state                = row[5]
        zip_code.county               = row[6]
        zip_code.timezone             = row[7]
        zip_code.area_codes           = row[8]
        zip_code.latitude             = row[9]
        zip_code.longitude            = row[10]
        zip_code.world_region         = row[11]
        zip_code.country              = row[12]
        zip_code.decommissioned       = row[13]
        zip_code.estimated_population = row[14]
        zip_code.notes                = row[15]
        zip_code.save!

        progress_bar.increment
      end
    end

    def import_fips
      states = ZipCode.uniq.pluck(:state)
      progress_bar = ProgressBar.create(
          title: 'Fips Codes',
          starting_at: 1,
          total: states.length + 5, # buffer
          format: '%a |%b>>%i| %p%% %t'
      )
      states.each do |state|
        progress_bar.log "Importing #{state}"

        url = "http://www.epa.gov/enviro/html/codes/#{state.downcase}.html"
        begin
          doc = Nokogiri::HTML(open(url))
          abbr, fips_code, name = doc.css('table').first.css('td').map(&:text)
          state_fips_code = StateFipsCode.first_or_create!(
              state_name: name,
              state_abbr: abbr,
              fips_code: fips_code
          )

          doc.css('table').last.css('tr').each do |tr|
            county_name, fips_code = tr.css('td').map(&:text)
            next unless county_name && fips_code

            county_fips_code = CountyFipsCode.first_or_create!(
                fips_state_fips_code_id: state_fips_code.id,
                county_name: county_name,
                fips_code: fips_code
            )
          end
        rescue OpenURI::HTTPError
          puts "URL not available: #{url}"
        end

        progress_bar.increment
      end
    end

  end
end
