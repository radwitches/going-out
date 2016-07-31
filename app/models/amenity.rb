class Amenity < ApplicationRecord
  def self.near(destination)
    kilometer = 0.02
    where(<<-SQL, destination.gid
        ST_DWithin(
            point,
            (select geom from destinations where gid = ?),
            #{kilometer}
          )
        SQL
    )
  end
end
