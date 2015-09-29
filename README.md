[![Gem Version](https://badge.fury.io/rb/has_order.svg)](http://badge.fury.io/rb/has_order)
[![Build Status](https://travis-ci.org/kolesnikovde/has_order.svg?branch=master)](https://travis-ci.org/kolesnikovde/has_order)
[![Code Climate](https://codeclimate.com/github/kolesnikovde/has_order/badges/gpa.svg)](https://codeclimate.com/github/kolesnikovde/has_order)
[![Test Coverage](https://codeclimate.com/github/kolesnikovde/has_order/badges/coverage.svg)](https://codeclimate.com/github/kolesnikovde/has_order)

# has_order

has_order is an ORM extension that provides user-sorting capabilities.

## Features:

- Optimized to reduce the number of update operations (by using floating intervals between adjacent elements).
- ActiveRecord 4.x and Mongoid 4.x support.
- Convenient scope-oriented API.

## Installation

Add this line to your application's Gemfile:

    gem 'has_order'

And then execute:

    $ bundle

## Usage

Example model:
```sh
$ rails g model Item \
  name:string \
  position:integer
```
```ruby
class Item < ActiveRecord::Base
  has_order
end
```

or Mongoid document:
```ruby
class Item
  include Mongoid::Document
  include Mongoid::HasOrder

  has_order

  # NOTE: position column will be configured automatically.
  field :name, type: String
end
```

Options:
```
scope             - optional, proc, symbol or an array of symbols.
position_column   - optional, default 'position'.
position_interval - optional, default 1000.
```

Methods:
```ruby
foo, bar, baz, qux = Item.create([
  { name: 'foo' },
  { name: 'bar' },
  { name: 'baz' },
  { name: 'qux' }
])

Item.at(foo.position) # => foo
Item.ordered          # => [ foo, bar, baz, qux ]

baz.higher     # => [ qux ]
baz.and_higher # => [ baz, qux ]
baz.lower      # => [ foo, bar ]
baz.and_lower  # => [ foo, bar, baz ]
baz.previous   # => bar
baz.prev       # => bar
baz.next       # => qux

baz.move_before(bar)
Item.ordered
# => [ foo, baz, bar, qux ]

foo.move_after(qux)
Item.ordered
# => [ baz, bar, qux, foo ]

baz.move_to(qux)
Item.ordered
# => [ bar, baz, qux, foo ]

foo.position = bar.position
foo.save!
# => [ foo, bar, baz, qux ]
```

## See also

- [ranked-model](https://github.com/mixonic/ranked-model)

## License

MIT
