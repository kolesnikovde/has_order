class Item
  include Mongoid::Document
  include Mongoid::HasOrder

  field :name,     type: String
  field :category, type: String
end
