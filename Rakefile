Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

task default: %w[run]

task :run do
  Tournament.run
end
