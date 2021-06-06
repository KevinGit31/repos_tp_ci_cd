Vagrant.configure("2") do |config|

	config.vm.define "enjenkins" do |enjenkins|
		enjenkins.vm.hostname = 'enjenkins'
		enjenkins.vm.box = "ubuntu/bionic64"
		enjenkins.vm.provider "virtualbox" do |vb|
			vb.memory = 2048
			vb.cpus = 1
		end

		enjenkins.vm.network "private_network", ip: "172.30.1.15"
		enjenkins.vm.synced_folder "project/enjenkins", "/home/project", create: true

		# Provisioning
		enjenkins.vm.provision :shell, :path => "provision_jenkins.sh"
 
	end

	config.vm.define "envdeploy" do |envdeploy|
		envdeploy.vm.hostname = 'envdeploy'
		envdeploy.vm.box = "ubuntu/bionic64"
		envdeploy.vm.provider "virtualbox" do |vb|
			vb.memory = 2048
			vb.cpus = 1
		end

		envdeploy.vm.network "private_network", ip: "172.30.1.16"
		envdeploy.vm.synced_folder "project/envdeploy", "/home/project", create: true

		# Provisioning
		envdeploy.vm.provision :shell, :path => "provision_deploy.sh"
		envdeploy.vm.provision :shell, :path => "provision_deploy_create_user_jenkins.sh"
	end
 
end