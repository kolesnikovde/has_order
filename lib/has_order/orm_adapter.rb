module HasOrder
  # :nocov:
  module OrmAdapter
    if defined?(::ActiveRecord)
      ::ActiveRecord::Base.extend(HasOrder)
    end

    if defined?(::Mongoid)
      module ::Mongoid::HasOrder
        def self.included(base)
          base.extend(::HasOrder)
        end
      end
    end

    def self.included(base)
      base.class_eval do
        if defined?(::ActiveRecord) and self < ::ActiveRecord::Base
          require 'has_order/orm_adapter/active_record'
          include ActiveRecord
        elsif defined?(::Mongoid) and self < ::Mongoid::Document
          require 'has_order/orm_adapter/mongoid'
          include Mongoid
        end
      end
    end
  end
  # :nocov:
end
