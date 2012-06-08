directory "lib"

file "wmls-0.1.13.gem"  => ["wmls.gemspec", "lib/wmls.rb", "bin/wmls"] do
  sh "gem build wmls.gemspec"
end

task :default => "wmls-0.1.13.gem"

