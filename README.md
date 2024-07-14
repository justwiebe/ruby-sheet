# ruby-sheet
Ruby Gem for parsing Excel Spreadsheets

## Usage
```ruby
require 'ruby_sheet'

workbook = RubySheet::Parser.parse('/path/to/my/file.xlsx')
worksheet1 = workbook.worksheets.first
puts worksheet1.values
```

## Development

### Debugging Excel files
To inspect a XLSX file in the `spec/fixtures` folder, there is a rake command that will unzip the contents into the
`spec/fixtures/inspect/{name}/` folder. Simply run `rake inspect\['{file_name}'\]` in the console.

E.g. `rake inspect\['simple_values'\]` will unzip `spec/fixtures/simple_values.xlsx` into the `spec/fixtures/inspect/simple_values/` folder.
