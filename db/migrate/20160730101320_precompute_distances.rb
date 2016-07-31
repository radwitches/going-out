class PrecomputeDistances < ActiveRecord::Migration[5.0]
  def change

    require 'csv'

    CSV.foreach("db/seeds/toiletmap.csv", headers: true) do |row|
      next if row["Status"] != "Verified"

      Amenity.create!(
        point: Point.new(
          row["Longitude"].to_f,
          row["Latitude"].to_f
        ),
        icon: row["IconURL"],
        icon_alt: row["IconAltText"],
        extras: {
          baby_change: row["BabyChange"],
        }
      )
    end

    create_table :destination_amenities do |t|
      t.integer :destination_id, null: false
      t.integer :amenity_id, null: false
    end

    Destination.find_each do |dest|
      dest.amenities = Amenity.near(dest)
    end
  end
end
