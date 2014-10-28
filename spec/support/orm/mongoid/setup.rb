require 'mongoid'
require 'has_order'

Mongoid.configure do |config|
  config.connect_to('mongoid_has_order_test')
end

require_relative 'item_model'

RSpec.configure do |config|
  config.after(:each) { Mongoid.purge! }
end
