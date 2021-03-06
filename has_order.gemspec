lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'has_order/version'

Gem::Specification.new do |spec|
  spec.name          = 'has_order'
  spec.version       = HasOrder::VERSION

  spec.authors       = ['Kolesnikov Danil']
  spec.email         = ['kolesnikovde@gmail.com']
  spec.description   = 'has_order is an ORM extension that provides user-sorting capabilities.'
  spec.summary       = 'has_order is an ORM extension that provides user-sorting capabilities.'
  spec.homepage      = 'https://github.com/kolesnikovde/has_order'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',      '~> 1'
  spec.add_development_dependency 'rake',         '~> 10'
  spec.add_development_dependency 'rspec',        '~> 3'

  spec.add_development_dependency 'sqlite3',      '~> 1'
  spec.add_development_dependency 'activerecord', '~> 4'
  spec.add_development_dependency 'mongoid',      '~> 4'

  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.add_runtime_dependency 'activesupport', '~> 4'
end
