def vm(opt)
  module_name = opt.fetch(:module).to_s || raise(ArgumentError, 'Must provide puppet module name')
  hostname = opt.fetch(:hostname, module_name).to_s
  memory = opt.fetch(:memory, 512)
  cpu = opt.fetch(:cpu, 1)
  box = opt.fetch(:box).to_s || raise(ArgumentError, 'Must provide box type.')
  url = opt.fetch(:url, '').to_s

  Vagrant.configure('2') do |conf|

    conf.vm.synced_folder './', "/etc/puppet/modules/#{module_name}"
    conf.vm.synced_folder 'spec/fixtures/modules', '/tmp/puppet/modules'

    conf.vm.define module_name.to_sym do |mod|
      mod.vm.box = box
      mod.vm.box_url = url

      mod.vm.hostname = hostname
      mod.vm.provider :vmware_fusion do |f|
        f.vmx['displayName'] = hostname
        f.vmx['memsize'] = memory
        f.vmx['numvcpus'] = cpu
      end

      mod.vm.provision :puppet do |p|
        p.manifests_path = 'tests'
        p.manifest_file = ENV['VAGRANT_MANIFEST'] || 'init.pp'
        p.options = '--modulepath "/etc/puppet/modules:/tmp/puppet/modules"'
      end
    end
  end
end

