class CreateFipsCountyFipsCodes < ActiveRecord::Migration
  def change
    create_table :fips_county_fips_codes do |t|
      t.integer :state_fips_code_id
      t.string :county_name
      t.string :fips_code
    end

    add_index :fips_county_fips_codes, [:state_fips_code_id, :county_name], unique: true, name: :index_fips_county_fips_codes
  end
end
