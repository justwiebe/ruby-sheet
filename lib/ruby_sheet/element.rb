# frozen_string_literal: true

module RubySheet
  class Element
    # Override the default inspect so that debugging is easier
    def inspect
      "<#{self.class.name} #{inspect_attributes.join(' ')}>"
    end

    private

    def inspect_attributes
      methods = (self.class.instance_methods - self.class.superclass.instance_methods).map(&:to_s)
      methods = methods.select do |method|
        !method.end_with?('=') && methods.include?("#{method}=") && inspect_exclude_attributes.include?(method)
      end
      methods.map { |method| "#{method}='#{send(method)}'" }
    end

    def inspect_exclude_attributes
      ['workbook_context']
    end
  end
end
