# frozen_string_literal: true

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'semver'

def s_version
  SemVer.find.format '%M.%m.%p%s'
end
require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'ruby_sheet'
  gem.homepage = 'http://github.com/justwiebe/ruby_sheet'
  gem.license = 'MIT'
  gem.summary = %(TODO: one-line summary of your gem)
  gem.description = %(TODO: longer description of your gem)
  gem.email = 'justin@wiebes.world'
  gem.authors = ['Justin Wiebe']
  gem.version = s_version

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

task default: :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby_sheet #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :inspect, :fixture do |t, args|
  require 'zip'
  require 'nokogiri'
  base = Pathname.new(__dir__)

  path = base.join('spec', 'fixtures', 'inspect', args[:fixture])
  fixture = File.join(base, 'spec', 'fixtures', "#{args[:fixture]}.xlsx")
  FileUtils.rm_rf(path)

  Zip::File.open(fixture, create: true) do |zipfile|
    zipfile.each do |file|
      file_path = File.join(path, file.name)
      FileUtils.mkdir_p(File.dirname(file_path))

      doc = Nokogiri::XML(file.get_input_stream, &:noblanks)
      File.write(file_path, doc.to_xml)

      # zipfile.extract(file, file_path) unless File.exist?(file_path)
    end
  end
end
