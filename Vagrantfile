Vagrant.configure("2") do |config|

	config.vm.define "envdeploy" do |envdeploy|
		envdeploy.vm.hostname = 'envdeploy'
		envdeploy.vm.box = "ubuntu/bionic64"
		envdeploy.vm.provider "virtualbox" do |vb|
			vb.memory = 2048
			vb.cpus = 4
		end

		envdeploy.vm.network "private_network", ip: "172.30.1.16"
		envdeploy.vm.synced_folder "project/envdeploy", "/home/project", create: true

		# Provisioning
		envdeploy.vm.provision :shell, :path => "provision_deploy.sh"
		envdeploy.vm.provision :shell, :path => "provision_deploy_create_user_jenkins.sh"
	end
	
	config.vm.define "envjenkins" do |envjenkins|
		envjenkins.vm.hostname = 'envjenkins'
		envjenkins.vm.box = "ubuntu/bionic64"
		envjenkins.vm.provider "virtualbox" do |vb|
			vb.memory = 2048
			vb.cpus = 1
		end

		envjenkins.vm.network "private_network", ip: "172.30.1.15"
		envjenkins.vm.synced_folder "project/envjenkins", "/home/project", create: true

		# Provisioning
		envjenkins.vm.provision :shell, :path => "provision_jenkins.sh"
		envjenkins.vm.provision :shell, :path => "install_keypub_master_to_target.sh"
 
	end
 
end