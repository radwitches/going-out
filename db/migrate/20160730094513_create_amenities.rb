class CreateAmenities < ActiveRecord::Migration[5.0]
  def change
    enable_extension :hstore
    create_table :amenities do |t|
      t.geometry "point", limit: {
        :srid=>4283,
        :type=>"point"
      }
      t.string "icon", null: false, default: ""
      t.string "icon_alt", null: false, default: ""
      t.hstore :extras, null: false, default: {}
    end
  end
end
