Rails.application.routes.draw do

  mount Fips::Engine => "/fips"
end
