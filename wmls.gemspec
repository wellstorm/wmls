Gem::Specification.new do |s|
  s.name = %q{wmls}
  s.version = "1.0.3"
  s.date = %q{2016-04-20}
  s.authors = ["Hugh Winkler"]
  s.email = %q{hughw@hughw.net}
  s.summary = %q{Calls GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on a WITSML server.}
  s.homepage = %q{https://github.com/wellstorm/wmls/}
  s.description = %q{Wmls calls GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on a WITSML server.}
  s.files = [ "README.md", "LICENSE", "lib/wmls.rb"]
  s.executables = [ "wmls" ]
  s.licenses=["Apache-2.0"]
  s.required_ruby_version = '>= 2.7.5'
end
