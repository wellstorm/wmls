Gem::Specification.new do |s|
  s.name = %q{wmls}
  s.version = "0.1.16"
  s.date = %q{2015-07-18}
  s.authors = ["Hugh Winkler"]
  s.add_runtime_dependency "nokogiri", "~>1.6", "~>1.6"
  s.email = %q{hwinkler@drillinginfo.com}
  s.summary = %q{Calls GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on a WITSML server.}
  s.homepage = %q{https://github.com/wellstorm/wmls/}
  s.description = %q{Wmls calls GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on a WITSML server.}
  s.files = [ "README", "LICENSE", "lib/wmls.rb"]
  s.executables = [ "wmls" ]
  s.licenses = ["Apache-2.0"]
end
