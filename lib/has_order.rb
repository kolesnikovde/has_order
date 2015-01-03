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

    before_save :update_position

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

    def move_to(pos)
      self.position = pos
      save!
    end

    def move_before(node)
      move_to(node.position)
    end

    def move_after(node)
      move_to(node.position + 1)
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

    protected

    def update_position
      if set_default_position?
        set_default_position
      else
        ensure_position
      end
    end

    def set_default_position?
      position.nil?
    end

    def set_default_position
      self.position = list_scope.next_position
    end

    def ensure_position
      if list_scope.at(position).exists?
        and_higher.shift(position_interval)
      end
    end

    def list_scope
      self.class.list_scope(self)
    end
  end
end
