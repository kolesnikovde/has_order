shared_examples 'list' do
  before(:each) do
    @foo, @bar, @baz, @qux = described_class.create([
      { name: 'foo', position: 1 },
      { name: 'bar', position: 2 },
      { name: 'baz', position: 3 },
      { name: 'qux', position: 4 }
    ])
  end

  def reload_items
    [ @foo, @bar, @baz, @qux ].each(&:reload)
  end

  describe 'position column' do
    it 'defaults to "position"' do
      expect(described_class.position_column).to eq(:position)
    end

    it 'provides accessor' do
      item = described_class.new
      item.position = 5
      expect(item.position).to eq(5)
    end
  end

  describe '.at' do
    it 'scopes position' do
      @foo.position = 5
      @foo.save

      expect(described_class.at(5).first).to eq(@foo)
    end
  end

  describe '.ordered' do
    it 'ranks items according to position' do
      expect(described_class.ordered).to eq([ @foo, @bar, @baz, @qux ])
    end
  end

  describe '.next_position' do
    it 'returns next available position' do
      @quux = described_class.create!(name: 'quux')

      expect(@quux.position).to be < described_class.next_position
    end
  end

  describe '#lower' do
    it 'returns items with position less or equal to the item position' do
      expect(@qux.lower).to match_array([ @foo, @bar, @baz ])
    end
  end

  describe '#and_lower' do
    it 'returns items with position less than or equal to the item position' do
      expect(@baz.and_lower).to match_array([ @foo, @bar, @baz ])
    end
  end

  describe '#higher' do
    it 'returns items with position greater than the item position' do
      expect(@foo.higher).to match_array([ @bar, @baz, @qux ])
    end
  end

  describe '#and_higher' do
    it 'returns items with position greater than or equal to the item' do
      expect(@bar.and_higher).to match_array([ @bar, @baz, @qux ])
    end
  end

  describe '#prev' do
    it 'returns previous item' do
      expect(@baz.prev).to eq(@bar)
      expect(@baz.previous).to eq(@bar)
    end
  end

  describe '#next' do
    it 'returns next item' do
      expect(@bar.next).to eq(@baz)
    end
  end

  context 'first item' do
    subject { @foo }

    it { expect(subject.lower).to be_empty }
    it { expect(subject.and_lower).to eq([ subject ]) }
    it { expect(subject.prev).to be_nil }
  end

  context 'last item' do
    subject { @qux }

    it { expect(subject.higher).to be_empty }
    it { expect(subject.and_higher).to eq([ subject ]) }
    it { expect(subject.next).to be_nil }
  end

  describe '#move_to' do
    it 'shifts item and higher items when the position is occupied' do
      @qux.move_to(@bar.position)

      reload_items

      expect(described_class.ordered).to eq([ @foo, @qux, @bar, @baz ])
    end
  end

  describe '#move_before' do
    it 'decreases item position' do
      prev_qux_position = @qux.position
      @qux.move_before(@foo)

      expect(@qux.position).to be < prev_qux_position
    end

    it 'shifts item and higher items when the position is occupied' do
      @baz.move_before(@bar)

      reload_items

      expect(described_class.ordered).to eq([ @foo, @baz, @bar, @qux ])
    end
  end

  describe '#move_after' do
    it 'increases item position' do
      prev_foo_position = @foo.position
      @foo.move_after(@qux)

      expect(@foo.position).to be > prev_foo_position
    end

    it 'shifts higher items when the position is occupied' do
      @foo.move_after(@bar)

      reload_items

      expect(described_class.ordered).to eq([ @bar, @foo, @baz, @qux ])
    end
  end

  describe '#save' do
    it 'shifts higher items when the position is occupied' do
      @foo.position = @bar.position + 1
      @foo.save!

      reload_items

      @qux.position = @baz.position
      @qux.save!

      reload_items

      @quux = described_class.create(name: 'quux', position: 0)

      reload_items

      expect(described_class.ordered).to eq([ @quux, @bar, @foo, @qux, @baz ])
    end
  end
end

shared_examples 'scoped list' do
  before(:each) do
    @foo, @bar, @baz, @qux = described_class.create([
      { name: 'foo', category: 'A' },
      { name: 'bar', category: 'A' },
      { name: 'baz', category: 'B' },
      { name: 'qux', category: 'B' }
    ])
  end

  it 'restricts scope' do
    expect(@bar.higher).to be_empty
    expect(@bar.and_lower).to match_array([ @bar, @foo ])
    expect(@baz.higher).to match_array([ @qux ])
    expect(@baz.lower).to be_empty
  end
end
