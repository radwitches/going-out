class Destination < ApplicationRecord
  # gid,          # id
  # park_reser,   # ???number
  # name,         # name
  # establishm    # date established,
  # total_park,   # ???number
  # area_type,    # what kind of park
  # style_type,   # what kind of park
  # shape_leng    # how long is the shape?
  # shape_area    # how big is the shape?
  # geom          # The geometry

  self.primary_key = :gid

  has_many :amenities, through: :destination_amenities
  has_many :destination_amenities

  def as_json(opts)
    point = Point.new(
      opts.delete(:from_lat),
      opts.delete(:from_lng)
    )

    super(opts).merge({
      centre: {lat: geom.centroid.x, lng: geom.centroid.y},
      distance: point.distance(geom),
      amenities: amenities
    })
  end

  def self.near(lat, lng)
    kilometer = 0.02
    includes(:amenities).where(<<-SQL
        ST_DWithin(
            geom,
            ST_GeomFromText(
              'POINT (#{Float(lng)} #{Float(lat)})',
              4283
            ),
            #{kilometer * 120}
          )
        SQL
    ).order <<-SQL
      ST_Distance(
        geom,
        ST_GeomFromText(
          'POINT (#{Float(lng)} #{Float(lat)})',
          4283
        )
      )
    SQL
  end
end
