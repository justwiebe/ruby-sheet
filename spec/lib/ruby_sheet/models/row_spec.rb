# frozen_string_literal: true

require 'spec_helper'

describe RubySheet::Row do
  let(:shared_strings) { RubySheet::SharedStrings.new(['String 1', 'String 2', 'String 3', 'String 4', 'String 5']) }
  let(:workbook_context) { RubySheet::WorkbookContext.new(shared_strings) }

  let(:cells) { '<c r="A1"> <v>1</v> </c>' }
  let(:xml) { %(<row r="1" spans="1:2"> #{cells} </row>) }
  subject { described_class.new(Nokogiri::XML.parse(xml).root, workbook_context) }

  it 'parses the value' do
    expect(subject.number).to eq(1)
    expect(subject.cells.size).to eq(2)
    expect(subject.start_column).to eq(1)
    expect(subject.end_column).to eq(2)
  end

  context 'with missing cells' do
    let(:cells) { '<c r="C1"> <v>1</v> </c> <c r="E1"> <v>4</v> </c>' }
    let(:xml) { %(<row r="1" spans="1:5"> #{cells} </row>) }

    it 'fills them in with blanks' do
      expect(subject.cells.size).to eq(5)

      expect(subject.cells[0].name).to eq('A1')
      expect(subject.cells[0].value).to eq(nil)

      expect(subject.cells[1].name).to eq('B1')
      expect(subject.cells[1].value).to eq(nil)

      expect(subject.cells[2].name).to eq('C1')
      expect(subject.cells[2].value).to eq(1)

      expect(subject.cells[3].name).to eq('D1')
      expect(subject.cells[3].value).to eq(nil)

      expect(subject.cells[4].name).to eq('E1')
      expect(subject.cells[4].value).to eq(4)
    end

    context 'with a span offset' do
      let(:cells) { '<c r="C1"> <v>1</v>' }
      let(:xml) { %(<row r="1" spans="2:5"> #{cells} </row>) }

      it 'fills in the offset correctly' do
        expect(subject.cells.size).to eq(4)

        expect(subject.cells[0].name).to eq('B1')
        expect(subject.cells[0].value).to eq(nil)

        expect(subject.cells[1].name).to eq('C1')
        expect(subject.cells[1].value).to eq(1)

        expect(subject.cells[2].name).to eq('D1')
        expect(subject.cells[2].value).to eq(nil)

        expect(subject.cells[3].name).to eq('E1')
        expect(subject.cells[3].value).to eq(nil)

        expect(subject.values).to eq([nil, 1, nil, nil])
      end
    end

    describe '#values' do
      it 'gets the values' do
        expect(subject.values).to eq([nil, nil, 1, nil, 4])
      end
    end
  end
end
