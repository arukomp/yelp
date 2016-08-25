require 'rails_helper'

describe ReviewsHelper, :type => :helper do
  context '#star_rating' do

    it 'does nothing if "N/A"' do
      expect(helper.star_rating('N/A')).to eq 'N/A'
    end

    it 'returns 5 full stars for 5 rating' do
      expect(helper.star_rating(5)).to eq '★★★★★'
    end

    it 'returns 3 full stars and 2 empty stars for 3' do
      expect(helper.star_rating(3)).to eq '★★★☆☆'
    end

    it 'returns four black stars and one white star for 3.5' do
      expect(helper.star_rating(3.5)).to eq '★★★★☆'
    end
  end
end
