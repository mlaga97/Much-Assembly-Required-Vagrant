Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-16.04"
	
	config.vm.provision "shell", path: "provision.sh"
	config.vm.provision "shell", inline: "cd /vagrant/Much-Assembly-Required/target && java -jar server-*.jar", run: "always"

	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "forwarded_port", guest: 8887, host: 8887
	
	config.vm.hostname = "muchassemblyrequired"
end
