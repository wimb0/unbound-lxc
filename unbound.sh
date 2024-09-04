#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/wimb0/unbound-lxc/main/build.func)
# Copyright (c) 2021-2024 tteck
# Modified by wimb0
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
     :::    ::: ::::    ::: :::::::::   ::::::::  :::    ::: ::::    ::: ::::::::: 
    :+:    :+: :+:+:   :+: :+:    :+: :+:    :+: :+:    :+: :+:+:   :+: :+:    :+: 
   +:+    +:+ :+:+:+  +:+ +:+    +:+ +:+    +:+ +:+    +:+ :+:+:+  +:+ +:+    +:+  
  +#+    +:+ +#+ +:+ +#+ +#++:++#+  +#+    +:+ +#+    +:+ +#+ +:+ +#+ +#+    +:+   
 +#+    +#+ +#+  +#+#+# +#+    +#+ +#+    +#+ +#+    +#+ +#+  +#+#+# +#+    +#+    
#+#    #+# #+#   #+#+# #+#    #+# #+#    #+# #+#    #+# #+#   #+#+# #+#    #+#     
########  ###    #### #########   ########   ########  ###    #### #########                            
 
EOF
}
header_info
echo -e "Loading..."
APP="Unbound"
var_disk="2"
var_cpu="1"
var_ram="512"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /etc/unbound ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
if (( $(df /boot | awk 'NR==2{gsub("%","",$5); print $5}') > 80 )); then
  read -r -p "Warning: Storage is dangerously low, continue anyway? <y/N> " prompt
  [[ ${prompt,,} =~ ^(y|yes)$ ]] || exit
fi
msg_info "Updating $APP LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated $APP LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} Unbound DNS should be available at:
         ${BL}${IP}:5335${CL} \n"
