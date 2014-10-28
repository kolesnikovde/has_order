module HasOrder
  module OrmAdapter
    def self.included(base)
      base.class_eval do
        # :nocov:
        if defined?(::ActiveRecord) and self < ::ActiveRecord::Base
          require 'has_order/orm_adapter/active_record'
          include ActiveRecord
        elsif defined?(::Mongoid) and self < ::Mongoid::Document
          require 'has_order/orm_adapter/mongoid'
          include Mongoid
        end
        # :nocov:
      end
    end
  end
end
