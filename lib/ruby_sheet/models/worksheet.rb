# frozen_string_literal: true

module RubySheet
  class Worksheet < Element
    attr_accessor :rows, :id, :workbook_rel_id, :workbook_context

    def initialize(xml, id, workbook_rel_id, workbook_context)
      super()
      @id = id
      @workbook_rel_id = workbook_rel_id
      @workbook_context = workbook_context
      @rows = xml.css('row').map { |row_xml| Row.new(row_xml, workbook_context) }
    end

    def values
      rows.map(&:values)
    end
  end
end
