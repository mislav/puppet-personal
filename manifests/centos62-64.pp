rbenv::install { 'deploy':
  group => 'deploy',
  home  => '/home/deploy'
}
rbenv::compile { '1.9.3-p194':
  user => 'deploy',
  home => '/home/deploy'
}

exec { 'rbenv::zsh':
  command => 'echo "source $(pwd)/.rbenvrc" >> .zshrc',
  user    => 'deploy',
  cwd     => '/home/deploy',
  path    => ['/bin', '/usr/bin', '/usr/sbin'],
  unless  => "grep rbenvrc /home/deploy/.zshrc 2>/dev/null",
  require => [ Rbenv::Install['deploy'], Package['zsh'] ]
}

package { 'zsh':
  ensure   => present,
  provider => yum
}

package { 'vim-enhanced':
  ensure   => present,
  provider => yum
}

user { 'deploy':
  ensure     => present,
  # gid        => 'admin',
  shell      => '/bin/zsh',
  home       => '/home/deploy',
  managehome => true
}

include postfix
postfix::config { 'relay_domains':
  value => "localhost mislav.net"
}

# ssh_authorized_key { 'id_rsa':
#   ensure => present,
#   user   => 'deploy',
#   type   => 'rsa',
#   key    => ???
# }
