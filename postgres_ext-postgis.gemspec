# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'postgres_ext/postgis/version'

Gem::Specification.new do |spec|
  spec.name          = 'postgres_ext-postgis'
  spec.version       = PostgresExt::Postgis::VERSION
  spec.authors       = ['Dan McClain']
  spec.email         = ['rubygems@danmcclain.net']
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'postgres_ext', '~> 2.1.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'm'
  spec.add_development_dependency 'bourne', '~> 1.3.0'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'dotenv'
  if RUBY_PLATFORM =~ /java/
    spec.add_development_dependency 'activerecord-jdbcpostgresql-adapter', '1.3.0.beta2'
  else
    spec.add_development_dependency 'pg', '~> 0.13.2'
  end
end
