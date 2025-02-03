#!/usr/bin/env bash
# Build all yes kernel config for testing different versions
set -eou pipefail

build_config() {
  folder=${1}
  major=${2}
  minor=${3}
  revision=${4:-1}
  cd /root
  if [[ ! -s /root/configs/${major}.${minor}.${revision}.config ]]; then
    wget --no-check-certificate "https://mirrors.edge.kernel.org/pub/linux/kernel/v${folder}/linux-${major}.${minor}.${revision}.tar.xz"
    tar Jxvf "linux-${major}.${minor}.${revision}.tar.xz"
    cd "linux-${major}.${minor}.${revision}"
    make allyesconfig
    cp .config "/root/configs/${major}.${minor}.${revision}.config"
    cd /root
    rm -rf "linux-${major}.${minor}.${revision}.tar.xz" "linux-${major}.${minor}.${revision}"
  fi
}

#build configs for 4.x up to 4.19
for i in {0..19}; do
  build_config 4.x 4 "$i"
done

#build configs for 5.x up to 5.15
for i in {1..15}; do
  build_config 5.x 5 "$i"
done

#build configs for 6.x up to 6.8
for i in {1..8}; do
  build_config 6.x 6 "$i"
done
