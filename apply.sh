# quick 'n' dirty script to push recipes and execute puppet to my server

self="$(basename "$0")"
rsync -vtr --exclude .git/ --exclude "/${self}" manifests modules root@mislav:puppet
ssh root@mislav '\
  cd puppet && \
  puppet apply --modulepath=modules --no-report \
    manifests/centos62-64.pp'
