require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.asset_host = 'http://localhost:3000'
end
