Gem::Specification.new do |s|
  s.name        = 'git-commit-story'
  s.executables << 'git-commit-story'
  s.version     = '0.0.4'
  s.date        = '2013-04-30'
  s.summary     = "StreamSend git commit wrapper"
  s.description = "Thin wrapper around git commit"
  s.authors     = ["Jeff Roush"]
  s.email       = 'jroush@ezpublishing.com'
  s.files       = ["lib/git-commit-story.rb"]
  s.homepage    = 'http://rubygems.org/gems/git-commit-story'

  s.add_dependency "grit"
  s.add_development_dependency "rspec"
  s.add_development_dependency "watchr"
end
