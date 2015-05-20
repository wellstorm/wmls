Gem::Specification.new do |s|
  s.name = %q{wmls}
  s.version = "0.1.15"
  s.date = %q{2012-08-14}
  s.authors = ["Hugh Winkler"]
  s.add_runtime_dependency "nokogiri", [">=0"]
  s.add_development_dependency "nokogiri", [">=0"]
  s.email = %q{hugh.winkler@wellstorm.com}
  s.summary = %q{Calls GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on a WITSML server.}
  s.homepage = %q{https://github.com/wellstorm/wmls/}
  s.description = %q{Wmls calls GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on a WITSML server.}
  s.files = [ "README", "LICENSE", "lib/wmls.rb"]
  s.executables = [ "wmls" ]
end
