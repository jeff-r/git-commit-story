Gem::Specification.new do |s|
  s.name        = "git-commit-story"
  s.executables << "git-commit-story"
  s.executables << "git-cs"
  s.version     = "0.1.5"
  s.date        = "2013-05-11"
  s.summary     = "StreamSend git commit wrapper"
  s.description = "Thin wrapper around git commit that adds a story id to commit messages"
  s.authors     = ["Jeff Roush"]
  s.email       = "jroush@ezpublishing.com"
  s.files       = ["lib/git-commit-story.rb"]
  s.homepage    = "https://github.com/Jeff-R/git-commit-story"
  s.files       = `git ls-files`.split($/)

  s.add_development_dependency "rspec"
  s.add_development_dependency "watchr"
end
