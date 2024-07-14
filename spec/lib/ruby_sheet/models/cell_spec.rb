# frozen_string_literal: true

require 'spec_helper'

describe RubySheet::Cell do
  let(:shared_strings) { RubySheet::SharedStrings.new(['String 1', 'String 2', 'String 3', 'String 4', 'String 5']) }
  let(:workbook_context) { RubySheet::WorkbookContext.new(shared_strings) }

  let(:xml) { '<c r="A1"> <v>1</v> </c>' }
  subject { described_class.parse(Nokogiri::XML.parse(xml).root, workbook_context) }

  context 'number value' do
    it 'parses the value' do
      expect(subject.value).to eq(1)
      expect(subject.name).to eq('A1')
      expect(subject.type).to eq('number')
    end
  end

  context 'string value' do
    let(:xml) { '<c r="A1" t="s"> <v>1</v> </c>' }

    it 'parses the value' do
      expect(subject.value).to eq('String 2')
      expect(subject.name).to eq('A1')
      expect(subject.type).to eq('string')
    end
  end

  describe '#column_position' do
    let(:cell) { described_class.new('BA99', nil, '1', workbook_context) }

    it 'converts the letters to numbers' do
      expect(cell.column_position).to eq(53)
    end
  end

  describe '#column_name' do
    it 'converts the letters to numbers' do
      expect(described_class.to_column_name(53, 99)).to eq('BA99')
    end
  end

  describe '#value' do
    let(:cell) { described_class.new('A1', 'string', '3', workbook_context) }

    context 'string' do
      it 'looks up the string from the shared strings table' do
        expect(cell.value).to eq('String 4')
      end
    end

    context 'number' do
      let(:cell) { described_class.new('A1', 'number', '3', workbook_context) }

      it 'returns the plain number' do
        expect(cell.value).to eq(3)
      end

      context 'float' do
        let(:cell) { described_class.new('A1', 'number', '3.14159', workbook_context) }

        it 'returns a float' do
          expect(cell.value).to eq(3.14159)
        end
      end

      context 'negative float' do
        let(:cell) { described_class.new('A1', 'number', '-5.2', workbook_context) }

        it 'returns a negative float' do
          expect(cell.value).to eq(-5.2)
        end
      end
    end
  end
end
