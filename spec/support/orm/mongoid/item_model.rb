class Item
  include Mongoid::Document

  extend HasOrder

  field :name,     type: String
  field :category, type: String
end
