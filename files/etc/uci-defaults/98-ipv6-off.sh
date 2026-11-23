#!/bin/sh
# 【2026-11-23 用户定】旁路由没有 IPv6 上行，LAN 上不发 v6。
# 一次性开机脚本（uci-defaults 语义）：跑完自删；step.sh 已完全不碰 dhcp.lan.ra，
# 所以之后你在 LuCI / uci 里改回 server 不会被覆盖。
#
# 手动恢复：
#   uci set dhcp.lan.ra='server'; uci set dhcp.lan.dhcpv6='server'
#   uci set dhcp.lan.ndp='server'; uci commit dhcp; /etc/init.d/odhcpd restart
[ -f /etc/config/dhcp ] || exit 0
uci -q get dhcp.lan >/dev/null 2>&1 || exit 0

uci set dhcp.lan.ra='disabled'
uci set dhcp.lan.dhcpv6='disabled'
uci set dhcp.lan.ndp='disabled'
uci commit dhcp || exit 1

/etc/init.d/odhcpd restart >/dev/null 2>&1 || true
logger -t ipv6-off "LAN RA/DHCPv6/NDP 已关闭（一次性开机脚本）" 2>/dev/null
exit 0
