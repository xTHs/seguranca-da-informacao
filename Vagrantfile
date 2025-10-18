Vagrant.configure("2") do |config|
  
  # VM VÍTIMA
  config.vm.define "vitima" do |vitima|
    vitima.vm.box = "ubuntu/jammy64"
    vitima.vm.hostname = "lab-victim"
    vitima.vm.network "private_network", ip: "192.168.56.10"
    
    vitima.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Vitima"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    vitima.vm.provision "shell", path: "provision/vitima_provision.sh"
  end

  # VM ATACANTE  
  config.vm.define "atacante" do |atacante|
    atacante.vm.box = "kalilinux/rolling"
    atacante.vm.hostname = "lab-attacker"
    atacante.vm.network "private_network", ip: "192.168.56.20"
    
    atacante.vm.provider "virtualbox" do |vb|
      vb.name = "SSH-Lab-Atacante"
      vb.memory = "4096"
      vb.cpus = 2
    end
    
    atacante.vm.provision "shell", path: "provision/atacante_provision.sh"
  end

end