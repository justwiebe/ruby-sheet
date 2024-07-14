# frozen_string_literal: true

module RubySheet
  class WorkbookContext < Element
    attr_accessor :shared_strings

    def initialize(shared_strings)
      super()
      @shared_strings = shared_strings
    end

    def self.load(zip)
      new(SharedStrings.load(zip))
    end
  end
end
