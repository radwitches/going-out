# https://www.data.vic.gov.au/data/dataset/pv-parkres-govhack-2016

class CreateDestinations < ActiveRecord::Migration[5.0]
  def up
    execute `shp2pgsql -s 4283 db/seeds/parks-data/Parks_Reserves.shp destinations`
  end
end
