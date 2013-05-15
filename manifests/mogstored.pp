# Not meant to be used by it's own - but included by parent mogilefs class
class mogilefs::mogstored inherits mogilefs {
  file { 'mogstored.conf':
    ensure  => $mogilefs::manage_file,
    path    => "${mogilefs::config_dir}/mogstored.conf",
    mode    => $mogilefs::config_file_mode,
    owner   => $mogilefs::config_file_owner,
    group   => $mogilefs::config_file_group,
    require => Package[$mogilefs::package],
    notify  => Service['mogstored'],
    content => template('mogilefs/mogstored.conf.erb'),
    replace => $mogilefs::manage_file_replace,
    audit   => $mogilefs::manage_audit,
    noop    => $mogilefs::noops,
  }

  # Data folder
  file { 'mogstored_datapath':
    ensure => 'directory',
    path   => $mogilefs::datapath,
    mode   => '0644',
    owner  => $mogilefs::config_file_owner,
    group  => $mogilefs::config_file_group,
  }

  # Service
  file { 'mogstored.init':
    ensure  => $mogilefs::manage_file,
    path    => '/etc/init.d/mogstored',
    mode    => '0755',
    owner   => $mogilefs::config_file_owner,
    group   => $mogilefs::config_file_group,
    require => Package[$mogilefs::package],
    content => $mogilefs::manage_mogstored_init_content,
    replace => $mogilefs::manage_file_replace,
    audit   => $mogilefs::manage_audit,
    noop    => $mogilefs::noops,
  }

  service { 'mogstored':
    ensure  => $mogilefs::manage_service_ensure,
    enable  => $mogilefs::manage_service_enable,
    require => [File['mogstored.init'], File['mogstored_datapath']],
    noop    => $mogilefs::noops,
  }

  # iowait stats dependency
  package { 'sysstat':
    ensure   => $mogilefs::manage_package_dependencies,
    noop     => $mogilefs::noops,
  }

  # Add mogstored host to tracker
  exec { 'mogilefs_addhost':
    path    => ['/bin', '/usr/local/bin', '/usr/bin'],
    command => "mogadm --trackers=${mogilefs::real_trackers} \
      host add ${::hostname} --ip=${::fqdn} --status=alive",
    unless  => "mogadm --trackers=${mogilefs::real_trackers} \
      host list | grep \s${::hostname}",
    require => Service[mogilefsd]
  }

  exec { 'mogilefs_enablehost':
    path    => ['/bin', '/usr/local/bin', '/usr/bin'],
    command => "mogadm --trackers=${mogilefs::real_trackers} \
      host mark ${::hostname} alive",
    unless  => "mogadm --trackers=${mogilefs::real_trackers} \
      host list | grep ^${::hostname}.*alive",
  }
}