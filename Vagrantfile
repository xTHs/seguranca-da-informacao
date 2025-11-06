Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = "ubuntu/jammy64"
  
  # VM DEFENSOR FRACO (Alvo)
  config.vm.define "def-weak" do |weak|
    weak.vm.hostname = "def-weak"
    weak.vm.network "private_network", ip: "192.168.56.10"
    
    weak.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Defensor"
      vb.memory = "512"
      vb.cpus = 1
      vb.gui = false
    end
    
    weak.vm.provision "shell", path: "provision/def_weak_provision.sh"
  end

  # VM ATACANTE (Testes)
  config.vm.define "atacante" do |atacante|
    atacante.vm.hostname = "atacante"
    atacante.vm.network "private_network", ip: "192.168.56.20"
    
    atacante.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Atacante"
      vb.memory = "512"
      vb.cpus = 1
      vb.gui = false
    end
    
    atacante.vm.provision "shell", path: "provision/atacante_provision.sh"
  end
end