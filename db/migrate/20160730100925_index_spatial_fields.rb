class IndexSpatialFields < ActiveRecord::Migration[5.0]
  def change
    change_table :destinations do |t|
      t.index :geom, using: :gist
    end
    change_table :amenities do |t|
      t.index :point, using: :gist
    end
  end
end
