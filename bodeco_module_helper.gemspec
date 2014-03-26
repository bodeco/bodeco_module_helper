# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = 'bodeco_module_helper'
  s.version = '0.0.1'

  s.authors     = ['Nan Liu', 'Dan Bode']
  s.email       = 'info@bodeco.io'
  s.homepage    = 'http://github.com/bodeco/bodeco_module/helper'
  s.summary     = 'Bodeco Puppet module helper.'
  s.description = 'Rake tasks and gem dependencies for puppet module testing.'
  s.licenses    = ['Apache 2.0']

  if facter_version = ENV['GEM_FACTER_VERSION']
    s.add_runtime_dependency 'facter', facter_version
  else
    s.add_runtime_dependency 'facter'
  end

  if puppet_version = ENV['GEM_PUPPET_VERSION'] || ENV['PUPPET_GEM_VERSION']
    s.add_runtime_dependency 'puppet', puppet_version
  else
    s.add_runtime_dependency 'puppet'
  end

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'rspec', '~> 2.11.0'
  s.add_runtime_dependency 'mocha', '~> 0.10.5'
  s.add_runtime_dependency 'puppetlabs_spec_helper'
  s.add_runtime_dependency 'rspec-puppet'
  s.add_runtime_dependency 'puppet-lint'

  s.files = Dir.glob('lib/**/*') + %w(LICENSE)
  s.require_path = 'lib'
end
