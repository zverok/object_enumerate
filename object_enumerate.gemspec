Gem::Specification.new do |s|
  s.name     = 'object_enumerate'
  s.version  = '0.0.1'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/object_enumerate'

  s.summary = 'Object#enumerate: Infinite enumerators'
  s.description = <<-EOF
  EOF
  s.licenses = ['MIT']

  s.files = `git ls-files lib LICENSE.txt *.md`.split($RS)
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.1.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubygems-tasks'
end