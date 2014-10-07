class CreateFipsCountyFipsCodes < ActiveRecord::Migration
  def change
    create_table :fips_county_fips_codes do |t|
      t.integer :fips_state_fips_code_id
      t.string :county_name
      t.string :fips_code

      t.timestamps
    end
  end
end
