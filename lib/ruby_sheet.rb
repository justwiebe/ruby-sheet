# frozen_string_literal: true

require 'zip'
require 'nokogiri'

require 'ruby_sheet/element'
require 'ruby_sheet/models/workbook'
require 'ruby_sheet/models/shared_strings'
require 'ruby_sheet/models/workbook_context'
require 'ruby_sheet/models/cell'
require 'ruby_sheet/models/row'
require 'ruby_sheet/models/worksheet'
# Dir[File.join(__dir__, 'ruby_sheet', 'models', '*.rb')].each { |file| require file }

module RubySheet
  class Parser
    def self.parse(file)
      ::Zip::File.open(file) do |zip_file|
        RubySheet::Workbook.parse_zip(zip_file, file)
      end
    rescue ::Zip::Error => e
      raise e, "XLSX file format error: #{e}", e.backtrace
    end
  end
end
