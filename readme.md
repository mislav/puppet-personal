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

1.  Using rbenv module doesn't work:

        Could not autoload rbenvgem:
          no such file to load -- puppet/provider/rbenvgem
          at /root/puppet/modules/rbenv/manifests/gem.pp:22

    I've read [Plugins in
    modules](http://docs.puppetlabs.com/guides/plugins_in_modules.html) doc page,
    but it doesn't shed any light to this issue. The files in
    `{modulepath}/{module}/lib/pupppet/provider/` should be autoloaded, IMO.

2.  Using postfix module doesn't work:

        notice: /Stage[main]/Postfix/Service[postfix]:
          Dependency Augeas[set postfix 'myorigin' to 'li503-173.members.linode.com']
          has failures: true

    It seems that it needs Augeas. This keeps getting mentioned in Puppet world,
    but even after briefly reading about this I'm no smarter as to what it is.

## The questions that I have

* How should I organize my manifests into multiple files once my setup grows?
* Is there a better way to run recipes on my remote box (currently rsync)
  without resorting to master-client model?
* How can I automate provisioning a new box that can't run puppet yet (no Ruby,
  rubygems, puppet gem installed); using old school shell scripts that I run via
  ssh?
