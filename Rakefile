Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
  # no rspec available
end


task :run, [:path] do |t, args|
  Tournament.run args[:path]
end
