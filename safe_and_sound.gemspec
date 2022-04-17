# frozen_string_literal: true

require File.expand_path('lib/safe_and_sound/version', __dir__)

Gem::Specification.new do |spec|
  spec.name        = 'safe_and_sound'
  spec.version     = SafeAndSound::VERSION
  spec.summary     = 'Sum Data Types'
  spec.description = 'A compact DSL to let you declare sum data types and define safe functions on them.'
  spec.authors     = ['Axel Tetzlaff']
  spec.email       = 'axel.tetzlaff@gmx.de'
  spec.files       = Dir['README', 'LICENSE', 'CHANGELOG.md', 'lib/**/*']
  spec.homepage    = 'https://github.com/axelerator/safe_and_sound'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.1'
  spec.extra_rdoc_files = ['README.md']

  spec.add_development_dependency 'minitest', '~> 5.15'
  spec.add_development_dependency 'minitest-reporters', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 13.0.6'
  spec.add_development_dependency 'rubocop', '~> 1.26'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
