class ListItem < Item
  has_order
end

class ScopedWithColumnListItem < Item
  has_order scope: :category
end

class ScopedWithLambdaListItem < Item
  has_order scope: ->(item){ where(category: item.category) }
end
