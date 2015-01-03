module HasOrder
  module OrmAdapter
    module Mongoid
      extend ActiveSupport::Concern

      included do
        field position_column, type: Integer
      end

      module ClassMethods
        def ordered
          asc(position_column)
        end

        def shift(interval)
          scoped.inc(position_column => interval)
        end

        def next_position
          max(position_column).to_i + position_interval
        end
      end

      def where_position(cmp)
        cmp = { gteq: :gte, lteq: :lte }[cmp] || cmp
        list_scope.where(position_column.send(cmp) => position)
      end
    end
  end
end
