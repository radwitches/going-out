# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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

