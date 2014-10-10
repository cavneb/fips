module Fips
  class StateFipsCode < ActiveRecord::Base
    has_many :county_fips_codes, class_name: "Fips::CountyFipsCode"

    validates :state_name, presence: true
    validates :state_abbr, presence: true
    validates :fips_code, presence: true

    def as_json
      ret = { 'id' => self.id, 'counties' => {} }
      county_fips_codes.each do |cfc|
        ret['counties'][cfc.sanitized_county_name] = cfc.id
      end
      ret
    end
  end
end
