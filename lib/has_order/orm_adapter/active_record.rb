module HasOrder
  module OrmAdapter
    module ActiveRecord
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          include InstanceMethods
        end
      end

      module ClassMethods
        def ordered
          order(arel_table[position_column].asc)
        end

        def shift!
          col = position_column
          update_all("#{col} = #{col} + #{position_shift_interval}")
        end

        def next_position
          maximum(position_column).to_i + position_shift_interval
        end
      end

      module InstanceMethods
        def where_position(cmp)
          col = self.class.arel_table[position_column]
          list_scope.where(col.send(cmp, position))
        end
      end
    end
  end
end
