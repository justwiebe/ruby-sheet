# frozen_string_literal: true

module RubySheet
  class SharedStrings < Element
    FILE = RubySheet::Workbook::ROOT.join('sharedStrings.xml')

    attr_accessor :strings

    def initialize(strings)
      super()
      @strings = strings
    end

    def self.load(zip)
      strings_entry = zip.find_entry(FILE)

      return new([]) if strings_entry.nil?

      xml = Nokogiri::XML.parse(strings_entry.get_input_stream)
      new(xml.css('t').map(&:text))
    end

    def find(index)
      strings[index]
    end
  end
end
