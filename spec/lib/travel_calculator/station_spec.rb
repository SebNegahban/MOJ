# frozen_string_literal: true

RSpec.describe Station do
  subject { Station.new('Archway', [2, 3]) }

  it 'allows read access of the station name' do
    expect(subject.name).to eq('Archway')
  end

  it 'allows read access of the station zones' do
    expect(subject.zones).to eq([2, 3])
  end
end
