<h2>Vagrant and Puppet configuration for Immodispo</h2>

This repo will setup everything you need to get started developing the Immodispo platform




**installation:**

1. Install Vagrant
2. Install Virtualbox
3. Clone this repository

Your folder structure should look like this:
<br><br>
<div>/immodispo/</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;/immodispo-vm/</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vagrantfile and other files are here</div>



<h4>Edit the Vagrantfile (config.vm.synced_folder) to point to the /immodispo/ folder above</h4>


If the folder structure is incorrect, the puppet provisioning will fail to install the MySQL schema located at <h3>/immodispo-vm/vagrant/files/install.sql</h3>