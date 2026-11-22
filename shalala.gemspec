# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'shalala/version'

Gem::Specification.new do |spec|
  spec.name = "shalala"
  spec.version = Shalala::VERSION
  spec.authors = ["Ryan Bigg"]
  spec.email = ["ryan@example.com"]

  spec.summary = "Rack app exposing current git commit"
  spec.description = "Mount at any path to return the current git commit SHA based on environment rules."
  spec.homepage = "https://github.com/radar/shalala"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir[
    "lib/**/*",
    "*.md",
    "*.gemspec",
    "Rakefile"
  ]

  spec.add_dependency "rack"

  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "rack-test"
end
