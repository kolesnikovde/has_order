[![Gem Version](https://badge.fury.io/rb/has_order.svg)](http://badge.fury.io/rb/has_order)
[![Build Status](https://travis-ci.org/kolesnikovde/has_order.svg?branch=master)](https://travis-ci.org/kolesnikovde/has_order)
[![Code Climate](https://codeclimate.com/github/kolesnikovde/has_order/badges/gpa.svg)](https://codeclimate.com/github/kolesnikovde/has_order)
[![Test Coverage](https://codeclimate.com/github/kolesnikovde/has_order/badges/coverage.svg)](https://codeclimate.com/github/kolesnikovde/has_order)

# has_order

Ordering behavior for ActiveRecord models and Mongoid documents.

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
  position:integer # Do not specify default value.
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
```

## License

Copyright (c) 2014 Kolesnikov Danil

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
