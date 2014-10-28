require 'spec_helper'
require 'list'

describe ListItem do
  it_behaves_like 'list'
end

describe ScopedWithColumnListItem do
  it_behaves_like 'scoped list'
end

describe ScopedWithLambdaListItem do
  it_behaves_like 'scoped list'
end
