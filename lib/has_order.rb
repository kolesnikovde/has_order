require 'has_order/version'
require 'has_order/orm_adapter'

module HasOrder
  # options - Options hash.
  #           :scope           - optional, proc, symbol or an array of symbols.
  #           :position_column - optional, default 'position'.
  #           :shift_interval  - optional, default 1000.
  def has_order options = {}
    include InstanceMethods

    cattr_accessor :position_column do
      options[:position_column] || :position
    end

    cattr_accessor :position_shift_interval do
      options[:shift_interval] || 1000
    end

    before_save :set_default_position, if: :set_default_position?

    scope :at, ->(pos){ where(position_column => pos) }

    define_list_scope(options[:scope])

    include HasOrder::OrmAdapter
  end

  module InstanceMethods
    def position
      self[position_column]
    end

    def position=(pos)
      self[position_column] = pos
    end

    def lower
      where_position(:lt)
    end

    def and_lower
      where_position(:lteq)
    end

    def higher
      where_position(:gt)
    end

    def and_higher
      where_position(:gteq)
    end

    def prev
      lower.ordered.last
    end

    def next
      higher.ordered.first
    end

    def move_to(pos)
      self.class.transaction do
        if node = list_scope.at(pos).first
          node.and_higher.shift!
        end

        self.position = pos
        save!
      end
    end

    def move_before(node)
      self.class.transaction do
        node_pos = node.position
        pos = node_pos > 0 ? node_pos - 1 : node_pos

        if list_scope.at(pos).exists?
          pos = node_pos
          node.and_higher.shift!
        end

        self.position = pos
        save!
      end
    end

    def move_after(node)
      self.class.transaction do
        node_pos = node.position
        pos = node_pos + 1

        if list_scope.at(pos).exists?
          node.higher.shift!
        end

        self.position = pos
        save!
      end
    end

    protected

    def list_scope
      self.class.list_scope(self)
    end

    def set_default_position
      self.position = list_scope.next_position
    end

    def set_default_position?
      position.nil?
    end
  end

  protected

  def define_list_scope(list_scope)
    scope :list_scope, case list_scope
    when Proc
      list_scope
    when nil
      ->(model) { where(nil) }
    else
      ->(model) { where(Hash[Array(list_scope).map{ |s| [ s, model[s] ] }]) }
    end
  end
end
