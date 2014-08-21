[![Gem Version](https://badge.fury.io/rb/has_order.svg)](http://badge.fury.io/rb/has_order)

# has_order

Provides list behavior to active_record models.

## Installation

Add this line to your application's Gemfile:

    gem 'has_order'

And then execute:

    $ bundle

## Usage

    $ rails g migration Item name:string \
                             position:integer \

```ruby
class Item < ActiveRecord::Base
  # :scope           - optional, proc, symbol or an array of symbols.
  # :position_column - optional, default 'position'.
  # :shift_interval  - optional, default 1000.
  has_order
end

foo, bar, baz, qux = Item.create([
  { name: 'foo' },
  { name: 'bar' },
  { name: 'baz' },
  { name: 'qux' }
])

Item.at(foo.position) # => foo

baz.higher            # => [ qux ]
baz.and_higher        # => [ baz, qux ]
baz.lower             # => [ foo, bar ]
baz.and_lower         # => [ foo, bar, baz ]

baz.move_before(bar) 
Item.ordered          # => [ foo, baz, bar, qux ]

foo.move_after(qux)
Item.ordered          # => [ baz, bar, qux, foo ]

baz.move_to(qux)
Item.ordered          # => [ bar, baz, qux, foo ]
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
