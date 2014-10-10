module Fips
  class ZipCode < ActiveRecord::Base
    def sanitized_county_name
      if self.state == 'PR'
        if self.county.present?
          if self.county == 'PR'
            self.primary_city.upcase
          else
            self.county.upcase
          end
        else
          self.primary_city.upcase
        end
      else
        c = (self.county || '').strip.upcase
        c = c.gsub(/\sCITY COUNTY$/i, '')
        c = c.gsub('O\'', 'O')
        c = c.gsub(/\sPARISH$/i, '')
        c = c.gsub(/\sBOROUGH$/i, '')
        c = c.gsub(/(\sCOUNTY|\s\(CITY\)|\sCITY)$/i, '')
        c = c.gsub('ST.', 'ST')
        c = c.gsub('STE.', 'STE')
        c = c.gsub(/\s\(.*\)$/i, '')
      end
    end
  end
end
