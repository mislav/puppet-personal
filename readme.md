# Mislav's Puppet experiments

I'm no sysadmin expert but I've set up a personal server—usually
Debian-flavored—countless times manually. Time to automatize this. I would want
to be able to provision a single box quickly for personal use, but I want to do
it via recipes that I can reply against another box whenever I want.

I've brushed with Chef, but getting disillusioned with its steep learning curve,
I've set out to try Puppet. Turns out, it's not any easier.

![I have no idea what I'm doing](http://i0.kym-cdn.com/photos/images/newsfeed/000/234/142/196.jpg)

Both Chef and Puppet seem designed for uses much more sophisticated than
provisioning a single machine for personal use. I'm not sure if they're the
right tool for the job for this.

## What services I need

* git
* rbenv
* postgresql, redis, mongo
* memcached
* nginx vhosts + Passenger, running multiple Ruby apps
* cron jobs for said apps
* postfix + dovecot, for personal email

My target is CentOS 6.2 for now, but would like to support Ubuntu too so these
recipes get some wider reusability.

## How I'm using puppet

I have installed "puppet" gem on the remote server. I rsync the "manifests" and
"modules" directories from my local machine up to the server and run "puppet
apply" there (see `apply.sh`).

I'm using 2 puppet modules found on GitHub as git submodules: "rbenv" and "postfix".

I test these recipes locally using Vagrant.

## The problems that I have

1.  Using rbenv module doesn't work with `puppet apply`:

        Could not autoload rbenvgem:
          no such file to load -- puppet/provider/rbenvgem
          at /root/puppet/modules/rbenv/manifests/gem.pp:22

    AFAIK, the files in `{modulepath}/{module}/lib/pupppet/provider/` should be
    autoloaded, but are not. **I've hacked this by setting**
    `RUBYLIB=modules/rbenv/lib`.

    Seems like [pluginsync won't work with
    apply](https://github.com/puppetlabs/puppet/pull/427) until v3.0?

## The questions that I have

* Do I really have to manually manage RUBYLIB for plugins to work?
* How should I organize my manifests into multiple files once my setup grows?
* Is there a better way to run recipes on my remote box (currently rsync)
  without resorting to master-client model?
* How can I automate provisioning a new box that can't run puppet yet (no Ruby,
  rubygems, or puppet gem installed); using old school shell scripts that I run
  via ssh?
* rbenv module currently manages bashrc; is there a way to hook into
  `rbenv::install` for zshrc and avoid doing [zsh support
  manually](https://github.com/mislav/puppet-personal/blob/55c3b61/manifests/centos62-64.pp#L10-17)?
  Or should I contribute to upstream rbenv module?
