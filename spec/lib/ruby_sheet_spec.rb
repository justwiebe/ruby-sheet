# frozen_string_literal: true

require 'spec_helper'

describe RubySheet::Parser do
  subject { described_class.parse('./spec/fixtures/simple_values.xlsx') }

  it 'parses a simple worksheet and gets basic values' do
    expect(subject).not_to be_nil
    expect(subject.worksheets.size).to eq(1)
    worksheet = subject.worksheets.first
    values = worksheet.values

    expect(values[0]).to eq([1, 2, 3, 4, 5, nil])
    expect(values[1]).to eq([nil, 'b', 'c', 'd', 'e', 's'])
    expect(values[2]).to eq(['b', 'c', 'a', 'd', 'r', nil])
    expect(values[3]).to eq([nil, nil, nil, 'zz', nil, nil])
    expect(values[4]).to eq([5_566_778_899, 3.1415899999999999, 5_566_778_895.8584099, -33.4, -5, 0])
  end
end
