# frozen_string_literal: true

require 'spec_helper'

describe RubySheet::Worksheet do
  let(:shared_strings) { RubySheet::SharedStrings.new(%w[a b c d e s zz r]) }
  let(:workbook_context) { RubySheet::WorkbookContext.new(shared_strings) }

  let(:xml) { File.open('spec/fixtures/worksheets/worksheet1.xml') { |f| Nokogiri::XML(f) } }
  subject { described_class.new(xml.root, '1', 'rId1', workbook_context) }

  it 'parses the value' do
    expect(subject.id).to eq('1')
    expect(subject.workbook_rel_id).to eq('rId1')
    expect(subject.rows.size).to eq(4)
  end

  describe 'values' do
    it 'collects values and has nil for empty cells' do
      values = subject.values
      expect(values.size).to eq(4)
      expect(values[0]).to eq([1, 2, 3, 4, 5, nil])
      expect(values[1]).to eq([nil, 'b', 'c', 'd', 'e', 's'])
      expect(values[2]).to eq(['b', 'c', 'a', 'd', 'r', nil])
      expect(values[3]).to eq([nil, nil, nil, 'zz', nil, nil])
    end
  end
end
