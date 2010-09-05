Gem::Specification.new do |s|
  s.name = 'maxminder'
  s.version = "1.0.0"
  s.platform = Gem::Platform::RUBY
  s.summary = "Simple (non-bloated) Ruby library for MaxMind"
  
  s.files = Dir.glob("{lib}/**/*")
  s.require_path = 'lib'
  s.has_rdoc = false

  s.author = "Adam Cooke"
  s.email = "adam@atechmedia.com"
  s.homepage = "http://github.com/adamcooke/maxminder"
end
