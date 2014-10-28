require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

orm_adapter = ENV['HAS_ORDER_ORM']

unless %w[activerecord mongoid].include?(orm_adapter)
  raise 'Unknown ORM.'
end

require "support/orm/#{orm_adapter}/setup"
require 'support/models'
