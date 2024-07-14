# frozen_string_literal: true

module RubySheet
  class Workbook < Element
    ROOT = ::Pathname.new('xl')
    FILE = ROOT.join('workbook.xml')
    REL = ROOT.join('_rels', 'workbook.xml.rels')

    attr_accessor :worksheets, :source_file, :context

    def initialize(worksheets, source_file, context)
      super()
      @worksheets = worksheets
      @source_file = source_file
      @context = context
    end

    def self.parse_zip(zip, source_file)
      workbook_entry = zip.find_entry(FILE)
      workbook_rel_entry = zip.find_entry(REL)
      raise 'No workbook found' if workbook_entry.nil?

      workbook = Nokogiri::XML.parse(workbook_entry.get_input_stream)
      workbook_rel = Nokogiri::XML.parse(workbook_rel_entry.get_input_stream)

      workbook_context = WorkbookContext.load(zip)

      worksheets = workbook.css('sheet').map do |sheet_element|
        sheet_id = sheet_element['sheetId']
        rel_id = sheet_element['r:id']

        # TODO: Lazy loading?
        sheet_filename = workbook_rel.at_css("Relationship[Id='#{rel_id}']")['Target']
        sheet_entry = zip.find_entry(ROOT.join(sheet_filename))
        Worksheet.new(Nokogiri::XML.parse(sheet_entry.get_input_stream), sheet_id, rel_id, workbook_context)
      end

      Workbook.new(worksheets, source_file, workbook_context)
    end
  end
end
