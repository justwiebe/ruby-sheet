# frozen_string_literal: true

module RubySheet
  class Row < Element
    attr_accessor :cells, :number, :start_column, :end_column, :workbook_context

    def initialize(xml, workbook_context)
      super()
      @number = xml['r'].to_i
      (@start_column, @end_column) = xml['spans'].split(':').map(&:to_i)
      @workbook_context = workbook_context
      @cells = init_cells xml
    end

    def values
      cells.map(&:value)
    end

    private

    def init_cells(xml)
      cells = []
      # TODO: what do we do if there are no values in column "A"?
      xml.css('c').each do |xml_cell|
        cell = Cell.parse(xml_cell, workbook_context)
        column_position = cell.column_position

        cells.push Cell.new(Cell.to_column_name(cells.size + start_column, number), nil,
          nil, workbook_context) while cells.size < column_position - start_column

        cells.push cell
      end

      cells.push Cell.new(Cell.to_column_name(cells.size + start_column, number), nil,
        nil, workbook_context) while cells.size < (end_column - start_column + 1)

      cells
    end
  end
end
