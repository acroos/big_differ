require_relative 'lib/big_differ/version'

Gem::Specification.new do |spec|
  spec.name          = "big_differ"
  spec.version       = BigDiffer::VERSION
  spec.authors       = ["acroos"]
  spec.email         = ["roos.austin@gmail.com"]

  spec.summary       = %q{Pull(merge) request have too many changes?  Try big_differ!}
  spec.description   = %q{big_differ is a tool for reviewing pull requests with too many changes to load in the browser.  you can view changes one-by-one and accept or comment.}
  spec.homepage      = "https://acroos.site"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aroos/big_differ"
  spec.metadata["changelog_uri"] = "https://github.com/aroos/big_differ/#"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "thor", "~> 1.0"

  spec.add_development_dependency "aruba", "~> 0.14"
  spec.add_development_dependency "cucumber", "~> 3.1"
  spec.add_development_dependency "rspec", "~> 3.9"
end
