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

  def as_json(opts)
    point = RGeo::Cartesian
      .preferred_factory(srid: 4283)
      .point(
        Float(opts.delete(:from_lat)),
        Float(opts.delete(:from_lng))
      )

    super(opts).merge({
      centre: geom.centroid.as_json,
      distance: point.distance(geom),
    })
  end

  def self.near(lat, lng)
    kilometer = 0.02
    where(<<-SQL
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
