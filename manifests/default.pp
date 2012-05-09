class chris::lea::python_software_properties {
  $package = "python-software-properties"
  package { $package:
    ensure => installed,
  }
}

define chris::lea::repo() {
  include chris::lea::python_software_properties
  exec { "chrislea-repo-added-${name}" :
    command => "/usr/bin/add-apt-repository ppa:chris-lea/${name}",
    creates =>
"/etc/apt/sources.list.d/chris-lea-${name}-${lsbdistcodename}.list",
    require => Package[$chris::lea::python_software_properties::package],
  }

  exec { "chrislea-repo-ready-${name}" :
    command => "/usr/bin/apt-get update",
    require => Exec["chrislea-repo-added-${name}"],
    creates =>
"/var/lib/apt/lists/ppa.launchpad.net_chris-lea_${name}_ubuntu_dists_${lsbdistcodename}_Release",
    timeout => 3600,
  }
}

class chris::lea::nodejs {
  chris::lea::repo { 'node.js': }
  package { ["nodejs", "nodejs-dev", "npm"]:
    ensure => installed,
    require => Chris::Lea::Repo['node.js'],
  }

  # other packages we need, e.g. g++ to compile node-expat
  package { ["g++", "libexpat1-dev"]:
    ensure => installed,
  }
}

include chris::lea::nodejs
