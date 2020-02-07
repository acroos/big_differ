require 'big_differ'

describe BigDiffer::Review do
  it 'can review' do
    expect(BigDiffer::Review.start).to eq(0)
  end
end