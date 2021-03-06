
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "carthage_support/version"

Gem::Specification.new do |spec|
  spec.name          = "carthage_support"
  spec.version       = CarthageSupport::VERSION
  spec.authors       = ["nrikiji"]
  spec.email         = ["nrikiji@gmail.com"]

  spec.summary       = "carthage support tool"
  spec.description   = "carthage support tool"
  spec.homepage      = "https://github.com/nrikiji/carthage_support"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "thor"
  spec.add_dependency "hashie"
  spec.add_dependency "xcodeproj"
end
