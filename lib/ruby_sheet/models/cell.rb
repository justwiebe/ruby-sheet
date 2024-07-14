# frozen_string_literal: true

module RubySheet
  class Cell < Element
    attr_accessor :name, :raw_value, :type, :workbook_context

    LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    BASE_STR = '123456789ABCDEFGHIJKLMNOPQ'

    TYPES = Hash.new('number').tap do |hash|
      hash['s'] = 'string'
    end

    def initialize(name, type, raw_value, workbook_context)
      super()
      @name = name
      @type = type
      @raw_value = raw_value
      @workbook_context = workbook_context
    end

    def self.parse(xml, workbook_context)
      new(xml['r'], TYPES[xml['t']], xml.at_css('v')&.text, workbook_context)
    end

    def value
      return nil if @raw_value.nil?
      return @raw_value.to_i if type == 'number'
      return workbook_context.shared_strings.find(@raw_value.to_i) if type == 'string'

      @raw_value
    end

    # Takes the cell name (e.g. BA29) and gets the position of the column (53 for BA)
    def column_position
      letters = name.match(/([A-Z]+)/)[1]
      letters.tr(LETTERS, BASE_STR).to_i(26)
    end

    # Takes a column position (e.g. 53) and the row number and converts it to a cell name (e.g. BA{row_number})
    def self.to_column_name(column_position, row_number)
      letters = column_position.to_s(26).tr(BASE_STR, LETTERS)
      "#{letters}#{row_number}"
    end
  end
end
