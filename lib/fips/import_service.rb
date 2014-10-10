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
      progress_bar = ProgressBar.create(
        title: 'Zip Codes',
        total: nil,
        throttle_rate: 0.1
      )

      CSV.foreach(zip_codes_file) do |row|
        next if ["MILITARY", "UNIQUE"].include? row[1]
        next if ["state", "PW", "FM", "MP", "MH", "VI", "AS", "GU"].include? row[5]
        next if row[13] == "1" # decommissioned

        if row[6].present?
          row[6] = row[6].gsub('Ã±', 'n')
          row[6] = row[6].gsub('Ã³', 'o')
          row[6] = row[6].gsub('¶', 'o')
        end

        # Other Fixes
        row[6] = "Dekalb"    if row[6] == "De Kalb County" && row[5] == "TN"

        # Zip code mappings
        row[6] = "New York"     if row[0] == "10200"
        row[6] = "Madison"      if row[0] == "22989"
        row[6] = "Tazewell"     if row[0] == "24619"
        row[6] = "Jefferson"    if row[0] == "25410"
        row[6] = "Mingo"        if row[0] == "25685"
        row[6] = "Allegany"     if row[0] == "21560"
        row[6] = "Lawrence"     if ["16140", "16155"].include? row[0]
        row[6] = "Fayette"      if row[0] == "15439"
        row[6] = "Oconee"       if row[0] == "30645"
        row[6] = "Caldwell"     if row[0] == "28667"
        row[6] = "Polk"         if row[0] == "30138"
        row[6] = "Hinds"        if row[0] == "39174"
        row[6] = "Williamson"   if row[0] == "62841"
        row[6] = "Union"        if row[0] == "71241"
        row[6] = "West Carroll" if row[0] == "71253"
        row[6] = "Caddo"        if row[0] == "73047"
        row[6] = "Denton"       if row[0] == "75033"
        row[6] = "Salt Lake"    if row[0] == "84129"
        row[6] = "Tulare"       if row[0] == "93633"


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
      StateFipsCode.delete_all
      CountyFipsCode.delete_all

      states = ZipCode.uniq.pluck(:state)
      progress_bar = ProgressBar.create(
        title: 'Fips Codes',
        starting_at: 1,
        total: states.length + 3, # buffer
        format: '%a |%b>>%i| %p%% %t'
      )
      states.each do |state|
        progress_bar.log "Importing #{state}"

        url = "http://www.epa.gov/enviro/html/codes/#{state.downcase}.html"
        begin
          doc = Nokogiri::HTML(open(url))
          abbr, fips_code, name = doc.css('table').first.css('td').map(&:text)
          state_fips_code = StateFipsCode.where(state_abbr: abbr).first_or_create!(
            state_name: name,
            fips_code: fips_code
          )

          doc.css('table').last.css('tr').each do |tr|
            county_name, fips_code = tr.css('td').map(&:text)
            next unless county_name && fips_code

            county_fips_code = Fips::CountyFipsCode.where(state_fips_code_id: state_fips_code).
                                              where(county_name: county_name).
                                              where(fips_code: fips_code).
                                              first_or_create!
          end
        rescue OpenURI::HTTPError
          puts "URL not available: #{url}"
        end

        progress_bar.increment
      end
    end

    def link_fips_to_zip_codes
      lookup = {}
      StateFipsCode.all.each do |sfc|
        lookup[sfc.state_abbr] = sfc.as_json
      end

      ZipCode.all.each do |zip_code|
        state = lookup[zip_code.state]
        if state
          sfc_id = lookup[zip_code.state]['id']
          if sfc_id.present? && lookup[zip_code.state]['counties'].present?
            cfc_id = lookup[zip_code.state]['counties'][zip_code.sanitized_county_name]
            if cfc_id
              # puts "#{zip_code.zip} [#{sfc_id}, #{cfc_id}]"
            else
              puts "[#{zip_code.id}] cfc does not exist for county #{zip_code.sanitized_county_name}, #{zip_code.state} [#{zip_code.zip}]"
            end
          else
            puts "-"
          end
        else
          puts "state not exist: #{zip_code.state}"
        end
      end
    end

  end
end
