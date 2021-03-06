# quick 'n' dirty script to push recipes and execute puppet to my server
dest=root@mislav

rsync -tr --exclude .git/ --exclude tests/ --exclude spec/ \
  init.sh manifests modules ${dest}:puppet

ssh $dest "
  cd puppet
  sh ./init.sh
  puppet apply --no-report \
    --modulepath=modules --libdir=modules/rbenv/lib \
    manifests/centos62-64.pp
"
