# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
vault_nodes = ENV["VAULT_NODES"].to_i # 0 to disable
consul_nodes = ENV["CONSUL_NODES"].to_i # 0 to disable
binary_type = ENV["BINARY_TYPE"] #prem, pro or oss
vault_playbook =  ENV["VAULT_PLAYBOOK"] || "ansible/vault/playbook.yml"


# Read JSON file with box details
cluster_vault = JSON.parse(File.read(File.join(File.dirname(__FILE__), "vault_cluster.json")))
cluster_consul = JSON.parse(File.read(File.join(File.dirname(__FILE__), "consul_cluster.json")))
puts "Requested:
consul_nodes = #{consul_nodes}
vault_nodes = #{vault_nodes}
binary_type = #{binary_type}
vault_playbook = #{vault_playbook}
"
#cluster_vault = #{cluster_vault}
#cluster_consul = #{cluster_consul}

created_vault = 1
created_consul = 1
consul_join_retry = []

cluster_consul.each do |cv|
  consul_join_retry.push(cv["ip_addr"])
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  if consul_nodes >= 1
    cluster_consul.each do |server|
      if created_consul <= consul_nodes
        config.vm.define server["name"] do |cfg|
          cfg.vm.provider :virtualbox do |vb, override|
            override.vm.box = server["box"]
            override.vm.synced_folder "./data/" + server["name"], "/mnt/data", 
            owner: 998, group: 1001, create: true
            #config.vm.box_version = "0.22"
            override.vm.network :private_network, ip: server["ip_addr"],
                                                  virtualbox__intnet: true,
                                                  netmask: "255.255.0.0"
            override.vm.network "forwarded_port", guest: 8500, host: 8500 + created_consul
            #override.vm.provision :shell, :path => "workspace/src/install_go.sh"
            override.vm.hostname = server["name"]
            vb.name = server["name"]
            vb.customize ["modifyvm", :id, "--memory", server["ram"]]
            vb.customize ["modifyvm", :id, "--cpus", server["vcpu"]]
            vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
            vb.customize ["modifyvm", :id, "--ioapic", "off"]
          end # cfg
          cfg.vm.provision :ansible do |ansible|
            ansible.playbook = "ansible/consul/playbook.yml"
            ansible.verbose = true
            ansible.extra_vars = {
              cluster_ip: server["ip_addr"],
              hostname: server["name"],
              join_retry: consul_join_retry.to_json
            }
          end
          cfg.vm.provision :hosts do |provisioner|
            provisioner.autoconfigure = true
            provisioner.sync_hosts = true
            #          provisioner.add_host '172.16.3.10', ['yum.mirror.local']
          end
        end #
        puts "Consul server #{server["name"]} for a total of #{created_consul} from #{consul_nodes}"
        created_consul = created_consul + 1
      end #
    end #cluster_consul
  end # vagrant
  if vault_nodes >= 1
    cluster_vault.each do |server|
      if created_vault <= vault_nodes
        config.vm.define server["name"] do |cfg|
          cfg.vm.provider :virtualbox do |vb, override|
            override.vm.box = server["box"]
            #config.vm.box_version = "0.22"
            override.vm.synced_folder ".", "/vagrant", disabled: true
            override.vm.network :private_network, ip: server["ip_addr"],
                                                  virtualbox__intnet: true,
                                                  netmask: "255.255.0.0"
            override.vm.network "forwarded_port", guest: 8200, host: 8200 + created_vault                                                
            #override.vm.provision :shell, :path => "workspace/src/install_go.sh"
            override.vm.hostname = server["name"]
            vb.name = server["name"]
            vb.customize ["modifyvm", :id, "--memory", server["ram"]]
            vb.customize ["modifyvm", :id, "--cpus", server["vcpu"]]
            vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
            vb.customize ["modifyvm", :id, "--ioapic", "off"]
          end # cfg
          cfg.vm.provision :ansible do |ansible|
            ansible.playbook = vault_playbook
            ansible.verbose = true
            ansible.extra_vars = {
              cluster_ip: server["ip_addr"],
              hostname: server["name"],
              join_retry: consul_join_retry.to_json
            }            
          end
          cfg.vm.provision :hosts do |provisioner|
            provisioner.autoconfigure = true
            provisioner.sync_hosts = true
          end
        end #
        puts "Vault server #{server["name"]} for a total of #{created_vault} from #{vault_nodes}"
        created_vault = created_vault + 1
      end #
    end #cluster_vault
  end # vagrant
end
