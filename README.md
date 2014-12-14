<h2>Vagrant and Puppet configuration for Immodispo</h2>

This repo will setup everything you need to get started developing the Immodispo platform




**installation:**

* Install Vagrant
* Install Virtualbox
* Clone this repository
* Edit the Vagrantfile (config.vm.synced_folder) to point to the cloned repository

Your folder structure should look like this:

/immodispo/
    /immodispo-vm/
        Vagrantfile and other files are here

If the folder structure is incorrect, the puppet provisioning will fail to install the MySQL schema located at <h3>/immodispo-vm/vagrant/files/install.sql</h3>