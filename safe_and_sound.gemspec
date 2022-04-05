# frozen_string_literal: true

require File.expand_path('lib/safe_and_sound/version', __dir__)

Gem::Specification.new do |spec|
  spec.name        = 'safe_and_sound'
  spec.version     = SafeAndSound::VERSION
  spec.summary     = 'Algebraic Data Types'
  spec.description = 'A compact DSL to give you ADTs and define safe functions on them.'
  spec.authors     = ['Axel Tetzlaff']
  spec.email       = 'axel.tetzlaff@gmx.de'
  spec.files       = ['lib/safe_and_sound.rb']
  spec.homepage    = 'https://github.com/axelerator/safe_and_sound'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'
  spec.extra_rdoc_files = ['README.md']

  spec.add_development_dependency 'rubocop', '~> 1.26'
  spec.add_development_dependency "minitest", ">= 5.15"
  spec.add_development_dependency "minitest-reporters", ">= 1.5"

  spec.metadata['rubygems_mfa_required'] = 'true'
end
