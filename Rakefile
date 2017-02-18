Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

task default: %w[run]

task :run, [:path] do |t, args|
  Tournament.run args[:path]
end
