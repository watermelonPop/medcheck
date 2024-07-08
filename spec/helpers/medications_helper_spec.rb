require 'rails_helper'

RSpec.describe MedicationsHelper, type: :helper do
  describe '#rgb_to_hex' do
    it 'converts rgb(255, 255, 255) to #ffffff' do
      expect(helper.rgb_to_hex('rgb(255, 255, 255)')).to eq('#ffffff')
    end

    it 'converts rgb(0, 0, 0) to #000000' do
      expect(helper.rgb_to_hex('rgb(0, 0, 0)')).to eq('#000000')
    end

    it 'converts rgb(255, 0, 0) to #ff0000' do
      expect(helper.rgb_to_hex('rgb(255, 0, 0)')).to eq('#ff0000')
    end

    it 'converts rgb(0, 255, 0) to #00ff00' do
      expect(helper.rgb_to_hex('rgb(0, 255, 0)')).to eq('#00ff00')
    end

    it 'converts rgb(0, 0, 255) to #0000ff' do
      expect(helper.rgb_to_hex('rgb(0, 0, 255)')).to eq('#0000ff')
    end

    it 'converts rgb(128, 128, 128) to #808080' do
      expect(helper.rgb_to_hex('rgb(128, 128, 128)')).to eq('#808080')
    end

    it 'handles single-digit values correctly' do
      expect(helper.rgb_to_hex('rgb(1, 2, 3)')).to eq('#010203')
    end

    it 'handles spaces in the input string' do
      expect(helper.rgb_to_hex('rgb( 255 , 255 , 255 )')).to eq('#ffffff')
    end

    it 'returns "#000000" for an empty string' do
      expect(helper.rgb_to_hex('')).to eq('#000000')
    end

    it 'returns "#000000" for invalid input' do
      expect(helper.rgb_to_hex('not an rgb string')).to eq('#000000')
    end
  end
end