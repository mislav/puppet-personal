# bootstrap machine for puppet
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

set -e

exist() {
  which "$1" >/dev/null 2>&1
}

if ! exist puppet; then
  if ! exist ruby; then
    if exist yum; then
      yum install --assumeyes ruby ruby-devel
    else
      apt-get update
      apt-get -y install irb libopenssl-ruby libreadline-ruby rdoc ri ruby ruby-dev
    fi
  fi

  if ! exist gem; then
    cd /tmp
    wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz -O- | tar xz
    cd rubygems-1.8.24
    ruby setup.rb
    echo gem: --no-ri --no-rdoc > /etc/gemrc
  fi

  gem install puppet -v '~> 2.7.18'
fi

if ! ruby -rubygems -e 'require "augeas"' 2>/dev/null
then
  if exist yum; then
    yum install --assumeyes augeas-devel
    gem install ruby-augeas
  else
    apt-get -y install augeas-lenses augeas-tools libaugeas-ruby
  fi
fi

# mkdir -p ~deploy/.ssh
# cp ~/.ssh/authorized_keys ~deploy/.ssh
# chown -R deploy:deploy ~deploy/.ssh
