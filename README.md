# Bodeco Puppet Module Spec Helper

This module brings in all the necessary dependencies and rake tasks for Puppet module development.

## Usage

When developing modules, simply use the bodec_module_helper in Gemfile:
```ruby
source "https://rubygems.org"
group :development, :test do
  gem 'bodeco_module_helper', :git => 'https://github.com/bodeco/bodeco_module_helper.git'
end
```

Add this to your project's Rakefile:
```ruby
begin
  require 'bodeco_module_helper/rake_tasks'
rescue LoadError
  puts 'Execute `bundle install` to deploy gem dependencies.'
end
```

The available rake tasks:
```shell
$ rake -T
rake beaker                         # Run beaker acceptance tests
rake beaker_nodes                   # List available beaker nodesets
rake build                          # Build puppet module package
rake clean                          # Clean a built module package
rake coverage                       # Generate code coverage information
rake help                           # Display the list of available rake tasks
rake lint                           # Check puppet manifests with puppet-lint
rake module:bump                    # Bump module version to the next minor
rake module:bump_commit             # Bump version and git commit
rake module:clean                   # Runs clean again
rake module:push                    # Push module to the Puppet Forge
rake module:release                 # Release the Puppet module, doing a clean, buil...
rake module:tag                     # Git tag with the current module version
rake spec                           # Run spec tests in a clean fixtures directory
rake spec_clean                     # Clean up the fixtures directory
rake spec_prep                      # Create the fixtures directory
rake spec_standalone                # Run spec tests on an existing fixtures directory
rake syntax                         # Check puppet manifest syntax
rake travis                         # Travis CI Tests
rake vagrant_destroy                # Vagrant VM shutdown and fixtures cleanup
rake vagrant_up[manifest,hostname]  # Vagrant VM power up and provision
rake validate                       # Validate manifests, templates, and ruby files ...
```
