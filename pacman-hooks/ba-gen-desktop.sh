#!/bin/bash

[[ "${HTTP_USER_AGENT:0:2}" != 'pa' ]] && exit 2

while read -r package; do
  packages=("$package" "${packages[@]}")
done

get_groups() {
  pkginfo=$1
  groups=$(echo "$pkginfo" | grep Groups | cut -d':' -f 2)
  category=""
  for group in $groups; do
    case "$group" in
    blackarch-anti-forensic)
      category="$category X-BlackArch-Anti-Forensic;"
      ;;
    blackarch-automation)
      category="$category X-BlackArch-Automation;"
      ;;
    blackarch-automobile)
      category="$category X-BlackArch-Automobile;"
      ;;
    blackarch-backdoor)
      category="$category X-BlackArch-Backdoor;"
      ;;
    blackarch-binary)
      category="$category X-BlackArch-Binary;"
      ;;
    blackarch-bluetooth)
      category="$category X-BlackArch-Bluetooth;"
      ;;
    blackarch-Code-audit)
      category="$category X-BlackArch-Code-Audit;"
      ;;
    blackarch-cracker)
      category="$category X-BlackArch-Cracker;"
      ;;
    blackarch-crypto)
      category="$category X-BlackArch-Crypto;"
      ;;
    blackarch-database)
      category="$category X-BlackArch-Database;"
      ;;
    blackarch-debugger)
      category="$category X-BlackArch-Debugger;"
      ;;
    blackarch-decompiler)
      category="$category X-BlackArch-Decompiler;"
      ;;
    blackarch-defensive)
      category="$category X-BlackArch-Defensive;"
      ;;
    blackarch-disassembler)
      category="$category X-BlackArch-Disassembler;"
      ;;
    blackarch-dos)
      category="$category X-BlackArch-Dos;"
      ;;
    blackarch-drone)
      category="$category X-BlackArch-Drone;"
      ;;
    blackarch-exploitation)
      category="$category X-BlackArch-Exploitation;"
      ;;
    blackarch-fingerprint)
      category="$category X-BlackArch-Fingerprint;"
      ;;
    blackarch-firmware)
      category="$category X-BlackArch-Firmware;"
      ;;
    blackarch-fuzzer)
      category="$category X-BlackArch-Fuzzer;"
      ;;
    blackarch-forensic)
      category="$category X-BlackArch-Forensic;"
      ;;
    blackarch-gpu)
      category="$category X-BlackArch-Gpu;"
      ;;
    blackarch-hardware)
      category="$category X-BlackArch-Hardware;"
      ;;
    blackarch-honeypot)
      category="$category X-BlackArch-Honeypot;"
      ;;
    blackarch-ids)
      category="$category X-BlackArch-Ids;"
      ;;
    blackarch-keylogger)
      category="$category X-BlackArch-Keylogger;"
      ;;
    blackarch-malware)
      category="$category X-BlackArch-Malware;"
      ;;
    blackarch-misc)
      category="$category X-BlackArch-Misc;"
      ;;
    blackarch-mobile)
      category="$category X-BlackArch-Mobile;"
      ;;
    blackarch-mobile-reversing)
      category="$category X-BlackArch-Mobile-Reversing;"
      ;;
    blackarch-networking)
      category="$category X-BlackArch-Networking;"
      ;;
    blackarch-nfc)
      category="$category X-BlackArch-Nfc;"
      ;;
    blackarch-packer)
      category="$category X-BlackArch-Packer;"
      ;;
    blackarch-proxy)
      category="$category X-BlackArch-Proxy;"
      ;;
    blackarch-radio)
      category="$category X-BlackArch-Radio;"
      ;;
    blackarch-recon)
      category="$category X-BlackArch-Recon;"
      ;;
    blackarch-reversing)
      category="$category X-BlackArch-Reversing;"
      ;;
    blackarch-scan)
      category="$category X-BlackArch-Scan;"
      ;;
    blackarch-scanner)
      category="$category X-BlackArch-Scanner;"
      ;;
    blackarch-sniffer)
      category="$category X-BlackArch-Sniffer;"
      ;;
    blackarch-social)
      category="$category X-BlackArch-Social;"
      ;;
    blackarch-spoof)
      category="$category X-BlackArch-Spoof;"
      ;;
    blackarch-stego)
      category="$category X-BlackArch-Stego;"
      ;;
    blackarch-tunnel)
      category="$category X-BlackArch-Tunnel;"
      ;;
    blackarch-unpacker)
      category="$category X-BlackArch-Unpacker;"
      ;;
    blackarch-voip)
      category="$category X-BlackArch-Voip;"
      ;;
    blackarch-webapp)
      category="$category X-BlackArch-Webapp;"
      ;;
    blackarch-windows)
      category="$category X-BlackArch-Windows;"
      ;;
    blackarch-wireless)
      category="$category X-BlackArch-Wireless;"
      ;;
    esac
  done
  echo "$category"
}

get_desc() {
  pkginfo="$1"
  desc=$(echo $pkginfo | grep Description)
  echo "$desc"
}

gen() {
  for package in "${packages[@]}"; do
    pkginfo=$(pacman -Si "blackarch/$package")
    package=$(echo "$pkginfo" | grep Name | cut -d':' -f 2 | sed 's/^ //g')
    desc=$(echo "$pkginfo" | grep Description | cut -d':' -f 2 | sed 's/^ //g')
    groups=$(get_groups "$pkginfo")

    if [[ -f "/usr/share/applications/$package.desktop" ]]; then
      continue
    fi

    if [[ ! $groups ]]; then
      continue
    fi

    cat >"/usr/share/applications/ba-$package.desktop" <<EOF
[Desktop Entry]
Name=$package
Icon=utilities-terminal
Comment=$desc
TryExec=/usr/bin/$package
Exec=sh -c '/usr/bin/$package;\$SHELL'
StartupNotify=true
Terminal=true
Type=Application
Categories=$groups
EOF

  done
}

rem() {
  for package in "${packages[@]}"; do
    if [[ -f "/usr/share/applications/ba-$package.desktop" ]]; then
      rm -f "/usr/share/applications/ba-$package.desktop"
    fi
  done
}

case $1 in
gen) gen ;;
rem) rem ;;
*)
  exit 2
  ;;
esac
