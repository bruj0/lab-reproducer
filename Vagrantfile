# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
vault_nodes = ENV["VAULT_NODES"].to_i # 0 to disable
consul_nodes = ENV["CONSUL_NODES"].to_i # 0 to disable
binary_type = ENV["BINARY_TYPE"] #prem, pro or oss

cluster_vault = {
  "vault01" => { :ip => "192.168.3.30", :cpus => 1, :mem => 1024, :box => "bruj0/hashitools-base" },
  "vault02" => { :ip => "192.168.3.31", :cpus => 1, :mem => 1024, :box => "bruj0/hashitools-base" },
  "vault03" => { :ip => "192.168.3.32", :cpus => 1, :mem => 1024, :box => "bruj0/hashitools-base" },
}
cluster_consul = {
  "consul01" => { :ip => "192.168.4.40", :cpus => 1, :mem => 1024, :box => "bruj0/hashitools-base" },
  "consul02" => { :ip => "192.168.4.41", :cpus => 1, :mem => 1024, :box => "bruj0/hashitools-base" },
  "consul03" => { :ip => "192.168.4.42", :cpus => 1, :mem => 1024, :box => "bruj0/hashitools-base" },
}

# Read JSON file with box details
cluster_vault = JSON.parse(File.read(File.join(File.dirname(__FILE__), "vault_cluster.json")))
cluster_consul = JSON.parse(File.read(File.join(File.dirname(__FILE__), "consul_cluster.json")))
puts "Requested:
consul_nodes = #{consul_nodes}
vault_nodes = #{vault_nodes}
binary_type = #{binary_type}
cluster_vault = #{cluster_vault}
cluster_consul = #{cluster_consul}
"
created_vault = 1
created_consul = 1

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  cluster_vault.each do |server|
    if created_vault <= vault_nodes
      consul_port = 8500 + created_vault
      ui_port = 8200 + created_vault
      cluster_port = 8300 + created_vault
      config.vm.define server["name"] do |cfg|
        cfg.vm.provider :virtualbox do |vb, override|
          config.vm.box = server["box"]
          #config.vm.box_version = "0.22"
          override.vm.network :private_network, ip: server["ip_addr"]
          override.vm.network "forwarded_port", guest: 8500, host: consul_port
          override.vm.network "forwarded_port", guest: 8200, host: ui_port
          override.vm.network "forwarded_port", guest: 8201, host: cluster_port
          #override.vm.provision :shell, :path => "scripts/install_vault.sh"
          #override.vm.provision :shell, :path => "workspace/src/install_go.sh"
          override.vm.hostname = server["name"]
          vb.name = server["name"]
          vb.customize ["modifyvm", :id, "--memory", server['ram']] 
          vb.customize ["modifyvm", :id, "--cpus", server['vcpu']] 
          vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
        end # cfg
      end #
      puts "Created #{server["name"]} for a total of #{created_vault} from #{vault_nodes}"
      created_vault = created_vault + 1
    end #
  end #cluster_vault
end # vagrant
