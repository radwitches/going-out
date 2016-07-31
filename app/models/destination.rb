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

  def self.field_scope
    select('
      gid,
      name,
      ST_ASGEOJSON(ST_CENTROID(geom)) as centre
    ')
  end

  def as_json(opts)
    point = Point.new(
      opts.delete(:from_lat),
      opts.delete(:from_lng)
    )

    # coordinates":[144.089384252525,-36.8069131047856]
    base = super(opts)
    if attributes[:centre]
      lat, lng = JSON.parse(attributes[:centre])['coordinates']
      base = base.merge({
        centre: {lat: lat, lng: lng},
      })
    end
    base.merge({
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
