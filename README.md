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

## Integration testing with Vagrant vms
The bodeco module helper can assist with creating vagrant vms to perform puppet integration tests.  This means executing
your puppet module code on real systems.  This will help you verify resource ordering. This is meant to not compete with
Beaker testing and should only be used when manual testing is required.  Please use Puppetlabs Beaker if you need automated
integration testing.

### Requirements
* Vagrant
* Virtualization (virtualbox or vmware workstation)
* Optional Plugins for vmware_workstation, vmware_fusion

### Usage
  1. Create a Vagrantfile in the root of your module code.  Add this to the vagrantfile.

    ```ruby
      begin
        require_relative 'spec/fixtures/modules/helper/lib/bodeco_module_helper/vagrant'
      rescue LoadError => e
        puts "Please ensure bundle global path is configured, and execute:\n$ bundle install\n$ bundle exec rake spec_prep"
        exit 1
      end
    ```

  2. For each type of vm you require for your module testing you will need to specify a vm definition like so:

    ```ruby
       vm(
            :hostname => 'mssql',
            :module => 'my_puppet_module',
            :type => :windows,
            :memory => 2048,
            :cpu => 2,
            :box => 'windows2008r2',
            :port => 1433,
            :gui => true
          )
    ```

Vm properties:

* hostname - is the hostname of the system vagrant will create
* module - is the module you are currently working on
* type - is the operating system type  (:linux or :windows)
* memory - is the amount of memory you wish to allocate for the vm in MB.
* cpu - is the number of virtualcpus you wish to allocate for the vm
* box - is the vagrant box you wish vagrant to use when creating the vm
* port - allows you to specify which ports you need forwarded so you can connect to them through the host
* gui - toggles headless mode.  (true if you want to see the VM, false will put it in the background)
