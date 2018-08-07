# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "theme-cv"
  spec.version       = "0.1.1"
  spec.authors       = ["Ludovic Bouguerra "]
  spec.email         = ["ludovic.bouguerra@kalyzee.com"]

  spec.summary       = %q{A short explanation of my awesome gem theme.}
  spec.homepage      = "https://github.com/theme-cv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README)}i) }

  spec.add_runtime_dependency "jekyll", "~> 3.5"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
