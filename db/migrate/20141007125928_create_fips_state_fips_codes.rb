class CreateFipsStateFipsCodes < ActiveRecord::Migration
  def change
    create_table :fips_state_fips_codes do |t|
      t.string :state_name
      t.string :state_abbr
      t.string :fips_code
    end

    add_index :fips_state_fips_codes, :state_abbr, unique: true
  end
end
