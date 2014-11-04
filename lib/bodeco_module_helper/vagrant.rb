def vm(opt)
  module_name = opt.fetch(:module).to_s || raise(ArgumentError, 'Must provide puppet module name')
  hostname = opt.fetch(:hostname, module_name).to_s
  memory = opt.fetch(:memory, 512)
  cpu = opt.fetch(:cpu, 1)
  box = opt.fetch(:box).to_s || raise(ArgumentError, 'Must provide box type.')
  url = opt.fetch(:url, '').to_s
  os_type = opt.fetch(:type, :linux)
  gui = opt.fetch(:gui, false)
  port = opt.fetch(:port, nil)
  iso = opt.fetch(:iso, nil)

  Vagrant.configure('2') do |conf|

    conf.vm.network(:forwarded_port, guest: port, host: port, auto_correct: true) if port

    if os_type == :windows
      conf.ssh.username = 'vagrant'
      conf.winrm.username = 'vagrant'
      conf.winrm.password = 'vagrant'
    end

    conf.vm.define hostname.to_sym do |mod|
      mod.vm.box = box
      mod.vm.box_url = url

      if os_type == :windows
        mod.vm.guest = :windows
        mod.vm.communicator = 'winrm'
        mod.vm.synced_folder './' , "/ProgramData/PuppetLabs/puppet/etc/modules/#{module_name}"
        mod.vm.synced_folder 'spec/fixtures/modules' , '/temp/modules'
      else
        mod.vm.synced_folder './', "/etc/puppet/modules/#{module_name}"
        mod.vm.synced_folder 'spec/fixtures/modules', '/tmp/puppet/modules'
      end

      mod.vm.hostname = hostname

      mod.vm.provider :vmware_fusion do |f|
        f.gui = gui
        f.vmx['displayName'] = hostname
        f.vmx['memsize'] = memory
        f.vmx['numvcpus'] = cpu
        if iso
          f.vmx['ide1:0.devicetype'] = "cdrom-image"
          f.vmx['ide1:0.filename'] = iso
        end
      end

      mod.vm.provider :vmware_workstation do |f|
        f.gui = gui
        f.vmx['displayName'] = hostname
        f.vmx['memsize'] = memory
        f.vmx['numvcpus'] = cpu
        if iso
          f.vmx['ide1:0.devicetype'] = "cdrom-image"
          f.vmx['ide1:0.filename'] = iso
        end
      end

      mod.vm.provider :virtualbox do |v|
        v.gui = gui
        v.name = hostname
        v.memory = memory
        v.cpus = cpu
      end

      if os_type == :windows
        manifest = ENV['VAGRANT_MANIFEST'] || 'init.pp'
        mod.vm.provision :shell, :inline => "puppet apply --modulepath 'C:/ProgramData/PuppetLabs/puppet/etc/modules;C:/temp/modules' --verbose C:/ProgramData/PuppetLabs/puppet/etc/modules/#{module_name}/tests/#{manifest}"
      else
        mod.vm.provision :puppet do |p|
          p.manifests_path = 'tests'
          p.manifest_file = ENV['VAGRANT_MANIFEST'] || 'init.pp'
          p.options = '--modulepath "/etc/puppet/modules:/tmp/puppet/modules"'
        end
      end
    end
  end
end

