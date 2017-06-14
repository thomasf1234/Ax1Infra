# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

@ui = Vagrant::UI::Colored.new

require 'yaml'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  servers_config = YAML.load_file('vagrant/config/servers.yaml')

  servers_config.each do |server_config|
    config.vm.define server_config["name"] do |cm_config|
      # Every Vagrant development environment requires a box. You can search for
      # boxes should be added using vagrant box add <box_name> <box_url>
      cm_config.vm.box = server_config["box"]

      # The url from where the 'config.vm.box' box will be fetched if it
      # doesn't already exist on the user's system.
      cm_config.vm.box_url = server_config["box_url"]

      # Enable ssh forward agent
      cm_config.ssh.forward_agent = true

      if server_config.has_key?("synced_folders")
        server_config["synced_folders"].each do |name, synced_folder|
          cm_config.vm.synced_folder synced_folder["src"], synced_folder["dst"],
                                     owner: "vagrant", group: "vagrant",
                                     mount_options: ["dmode=777", "fmode=777"]
        end
      end
      #hostname of this box
      cm_config.vm.hostname = server_config["hostname"]

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      cm_config.vm.network "private_network", ip: server_config["private_network_ip"]

      #bootstrap install puppet and deploy user
      cm_config.vm.provision "shell", path: "scripts/bootstrap.bash"

      cm_config.vm.provider "virtualbox" do |vb|
        vb.cpus = server_config["cpus"]
        vb.memory = server_config["memory"]
      end
    end
  end
end
