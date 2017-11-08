#!/usr/bin/ruby

Gem::Specification.new do |spec|
	spec.name        = 'ncplus'
	spec.version     = '0.0.1'
	spec.platform    = Gem::Platform::RUBY
	spec.authors     = ['Szymon Drejewicz']
	spec.email       = %w[szymon.drejewicz@gmail.com]
	spec.homepage    = 'https://github.com/ncplus/ncplus'
	spec.summary     = 'Ruby library to access NC-Plus (TV provider) EPG'
	spec.description = 'Ruby gem used to simplify TV EPG-like applications development'
	spec.license     = 'MIT'
	
	spec.add_dependency 'json', '~> 2.0', '>= 2.0.2'
	
	spec.required_ruby_version = '>= 2.4.0'
	
	spec.files         = ['lib/ncplus.rb']
end