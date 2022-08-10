#!/bin/sh

until tailscale \
	--socket=/tmp/tailscaled.sock \
	up \
	--authkey="${TAILSCALE_AUTH_KEY}" \
	--hostname="circleci-$(hostname)" \
	--accept-routes
do
	sleep 1
done

cat <<- EOF >> "${BASH_ENV}"
	export ALL_PROXY=socks5h://${PROXY}:1055/
	export HTTP_PROXY=http://${PROXY}:1054/
	export HTTPS_PROXY=http://${PROXY}:1054/
	export http_proxy=http://${PROXY}:1054/
	export https_proxy=http://${PROXY}:1054/
EOF
