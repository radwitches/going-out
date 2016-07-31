class PrecomputeDistances < ActiveRecord::Migration[5.0]
  def change
    create_table :destination_amenities do |t|
      t.integer :destination_id, null: false
      t.integer :amenity_id, null: false
    end

    Destination.find_each do |dest|
      dest.amenities = Amenity.near(dest)
    end
  end
end
