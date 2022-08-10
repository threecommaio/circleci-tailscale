#!/bin/sh

exec tailscaled \
	--tun=userspace-networking \
	--outbound-http-proxy-listen="${PROXY}":1054 \
	--socks5-server="${PROXY}":1055 \
	--socket=/tmp/tailscaled.sock \
	2> ~/tailscaled.log
