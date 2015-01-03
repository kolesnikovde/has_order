require 'has_order/version'
require 'has_order/orm_adapter'

module HasOrder
  DEFAULT_OPTIONS = {
    position_column: :position,
    position_interval: 1000
  }

  def has_order(options = {})
    include InstanceMethods
    extend ClassMethods

    setup_has_order_options(options)

    before_save :set_default_position, if: :set_default_position?

    define_list_scope(options[:scope])

    include HasOrder::OrmAdapter
  end

  module ClassMethods
    def at(pos)
      where(position_column => pos)
    end

    protected

    def setup_has_order_options(options)
      options.assert_valid_keys(:scope, :position_column, :position_interval)

      options.reverse_merge!(DEFAULT_OPTIONS)

      cattr_accessor(:position_column) { options[:position_column] }
      cattr_accessor(:position_interval) { options[:position_interval] }
    end

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

    alias_method :previous, :prev

    def next
      higher.ordered.first
    end

    def move_to(pos)
      self.class.transaction do
        if node = list_scope.at(pos).first
          node.and_higher.shift(position_interval)
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
          node.and_higher.shift(position_interval)
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
          node.higher.shift(position_interval)
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
end
