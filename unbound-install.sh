#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Unbound"
$STD apt-get install -y unbound
cat <<EOF >/etc/unbound/unbound.conf.d/wimbo.conf
server:
  verbosity: 0
  interface: 0.0.0.0
  port: 5335
  do-ip6: no
  do-ip4: yes
  do-udp: yes
  do-tcp: yes
  num-threads: 1
  hide-identity: yes
  hide-version: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-referral-path: yes
  use-caps-for-id: no
  harden-algo-downgrade: no
  qname-minimisation: yes
  aggressive-nsec: yes
  rrset-roundrobin: yes
  cache-min-ttl: 300
  cache-max-ttl: 14400
  msg-cache-slabs: 8
  rrset-cache-slabs: 8
  infra-cache-slabs: 8
  key-cache-slabs: 8
  serve-expired: yes
  root-hints: /var/lib/unbound/root.hints
  serve-expired-ttl: 3600
  edns-buffer-size: 1232
  prefetch: yes
  prefetch-key: yes
  target-fetch-policy: "3 2 1 1 1"
  unwanted-reply-threshold: 10000000
  rrset-cache-size: 256m
  msg-cache-size: 128m
  so-rcvbuf: 1m
  private-address: 192.168.0.0/16
  private-address: 169.254.0.0/16
  private-address: 172.16.0.0/12
  private-address: 10.0.0.0/8
  private-address: fd00::/8
  private-address: fe80::/10
  access-control: 192.168.0.0/16 allow
EOF
  wget -qO /var/lib/unbound/root.hints https://www.internic.net/domain/named.root
  systemctl enable -q --now unbound
  msg_info "Restarting Unbound to load new config"
  systemctl restart unbound
  msg_ok "Installed Unbound"
  

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
