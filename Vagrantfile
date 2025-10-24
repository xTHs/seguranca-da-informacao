Vagrant.configure("2") do |config|
  # Desativar pasta sincronizada padrão
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  # VM DEFENSOR FRACO
  config.vm.define "def-weak" do |weak|
    weak.vm.box = "ubuntu/jammy64"
    weak.vm.hostname = "def-weak.lab.local"
    weak.vm.network "private_network", ip: "192.168.56.10"
    
    weak.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Def-Weak"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    weak.vm.provision "shell", path: "provision/def_weak_provision.sh"
  end

  # VM DEFENSOR ENDURECIDO
  config.vm.define "def-hard" do |hard|
    hard.vm.box = "ubuntu/jammy64"
    hard.vm.hostname = "def-hard.lab.local"
    hard.vm.network "private_network", ip: "192.168.56.11"
    
    hard.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Def-Hard"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    hard.vm.provision "shell", path: "provision/def_hard_provision.sh"
  end

  # VM ATACANTE  
  config.vm.define "atacante" do |atacante|
    atacante.vm.box = "ubuntu/jammy64"
    atacante.vm.hostname = "atacante.lab.local"
    atacante.vm.network "private_network", ip: "192.168.56.20"
    
    atacante.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Atacante"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    atacante.vm.provision "shell", path: "provision/atacante_provision.sh"
  end

end