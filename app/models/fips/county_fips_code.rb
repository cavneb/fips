module Fips
  class CountyFipsCode < ActiveRecord::Base
    belongs_to :state_fips_code, class_name: "Fips::StateFipsCode"

    validates :state_fips_code_id, presence: true
    validates :county_name, presence: true
    validates :fips_code, presence: true

    def sanitized_county_name
      c = county_name.strip.upcase
      c = c.gsub(/\sCITY COUNTY$/i, '')
      c = c.gsub('O\'', 'O')
      c = c.gsub(/\sPARISH$/i, '')
      c = c.gsub(/\sBOROUGH$/i, '')
      c = c.gsub(/(\sCOUNTY|\s\(CITY\)|\sCITY)$/i, '')
      c = c.gsub('ST.', 'ST')
      c = c.gsub('STE.', 'STE')
      c = c.gsub(/\s\(.*\)$/i, '')

      c = 'DE WITT' if c == 'DEWITT'
      c = 'DE BACA' if c == 'DEBACA'
      c = 'PRINCE OF WALES-OUTER KETCHIKAN' if c == 'PRINCE OF WALES-OUTER KETCHIKA'
      c
    end
  end
end
