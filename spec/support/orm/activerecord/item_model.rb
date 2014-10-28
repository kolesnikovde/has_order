ActiveRecord::Schema.define(version: 0) do
  create_table :items, force: true do |t|
    t.string :name
    t.string :category
    t.string :type

    t.integer :position
  end
end

class Item < ActiveRecord::Base
  extend HasOrder
end
