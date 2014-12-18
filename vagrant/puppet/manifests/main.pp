class apt_update {
    exec { "aptGetUpdate":
        command => "sudo apt-get update",
        path => ["/bin", "/usr/bin"]
    }
}

class othertools {
    package { "git":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "vim-common":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "curl":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "htop":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "g++":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }
}

class nodejs {
  exec { "git_clone_n":
    command => "git clone https://github.com/visionmedia/n.git /home/vagrant/n",
    path => ["/bin", "/usr/bin"],
    require => [Exec["aptGetUpdate"], Package["git"], Package["curl"], Package["g++"]]
  }

  exec { "install_n":
    command => "make install",
    path => ["/bin", "/usr/bin"],
    cwd => "/home/vagrant/n",
    require => Exec["git_clone_n"]
  }

  exec { "install_node":
    command => "n stable",
    path => ["/bin", "/usr/bin", "/usr/local/bin"],  
    require => [Exec["git_clone_n"], Exec["install_n"]]
  }
}

class mongodb {
  class {'::mongodb::globals':
    manage_package_repo => true,
    bind_ip             => ["127.0.0.1"],
  }->
  class {'::mongodb::server':
    port    => 27017,
    verbose => true,
    ensure  => "present"
  }->
  class {'::mongodb::client': }
}

class redis-cl {
  class { 'redis': }
}

mysql::db::create{ 'immodispo': }

mysql::user::grant { immodispo_dev:
    user => 'immodispo',
    host => 'localhost',
    password => 'devpassword',
    database => 'immodispo',
}
->
exec { "install_schema":
  command => "mysql -u immodispo --password=devpassword immodispo < /vagrant/immodispo-vm/vagrant/files/install.sql",
  path => ["/bin", "/usr/bin", "/usr/local/bin"]
}


file { "/opt/immodispo":
    ensure => "directory",
    owner  => "vagrant",
    group  => "vagrant",
    mode   => 777,
}

file { "/opt/immodispo/listingImages":
    ensure => "directory",
    owner  => "vagrant",
    group  => "vagrant",
    mode   => 777,
}

file { "/opt/immodispo/agencyImages":
    ensure => "directory",
    owner  => "vagrant",
    group  => "vagrant",
    mode   => 777,
}


package { 'nginx':
	ensure => present,
	require => Exec['aptGetUpdate'],
}


service { 'nginx':
	ensure => running,
	require => Package['nginx'],
}

file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/vagrant',
	ensure => file,
    replace => true,
	require => Package['nginx'],
	source => 'puppet:///modules/nginx/vagrant',
    notify => Service['nginx'],
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable'],
	],
}

include apt_update
include othertools
include nodejs
include mongodb
include redis-cl
include mysql