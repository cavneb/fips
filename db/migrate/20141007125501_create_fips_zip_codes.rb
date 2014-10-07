class CreateFipsZipCodes < ActiveRecord::Migration
  def change
    create_table :fips_zip_codes do |t|
      t.integer :fips_state_fips_code_id
      t.integer :fips_county_fips_code_id
      t.string :zip
      t.string :zip_type
      t.string :primary_city
      t.string :acceptable_cities
      t.string :unacceptable_cities
      t.string :state
      t.string :county
      t.string :timezone
      t.string :area_codes
      t.float :latitude
      t.float :longitude
      t.string :world_region
      t.string :country
      t.integer :decommissioned
      t.integer :estimated_population
      t.string :notes

      t.timestamps
    end
  end
end
