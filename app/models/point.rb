module Point
  def self.new(lat, lng)
    RGeo::Cartesian
      .preferred_factory(srid: 4283)
      .point(
        Float(lat),
        Float(lng)
      )
  end
end
