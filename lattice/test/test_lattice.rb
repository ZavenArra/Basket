require 'test/unit'
require 'shoulda'
require_relative '../lib/lattice/lattice.rb'

class TestLattice < Test::Unit::TestCase
  context 'buildUIForDocument' do
    should "exist" do
      HTMLChunks = Lattice::buildUIForDocumentType('textOnly')
      assert_not_nil(HTMLChunks)
    end

    should "not return empty array" do
    end
  end
end
