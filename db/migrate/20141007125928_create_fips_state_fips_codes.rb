class CreateFipsStateFipsCodes < ActiveRecord::Migration
  def change
    create_table :fips_state_fips_codes do |t|
      t.string :state_name
      t.string :state_abbr
      t.string :fips_code

      t.timestamps
    end
  end
end
