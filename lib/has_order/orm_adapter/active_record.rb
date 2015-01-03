module HasOrder
  module OrmAdapter
    module ActiveRecord
      extend ActiveSupport::Concern

      module ClassMethods
        def ordered
          order(arel_table[position_column].asc)
        end

        def shift(interval)
          update_all("#{position_column} = #{position_column} + #{interval}")
        end

        def next_position
          maximum(position_column).to_i + position_interval
        end
      end

      def where_position(cmp)
        arel_column = self.class.arel_table[position_column]

        list_scope.where(arel_column.send(cmp, position))
      end
    end
  end
end
