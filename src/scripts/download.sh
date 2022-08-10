#!/bin/sh

if ! command -v tailscale --version > /dev/null 2>&1
then
	echo "Tailscale is not installed, installing..."
	MINOR=$(echo "${VERSION}" | awk -F '.' '{print $2}')

	if [ $((MINOR % 2)) -eq 0 ]
	then
		URL="https://pkgs.tailscale.com/stable/tailscale_${VERSION}_amd64.tgz"
	else
		URL="https://pkgs.tailscale.com/unstable/tailscale_${VERSION}_amd64.tgz"
	fi

	curl "${URL}" -o tailscale.tgz
	tar -C "${HOME}" -xzf tailscale.tgz
	rm tailscale.tgz

	TSPATH="${HOME}/tailscale_${VERSION}_amd64"
	sudo mv "${TSPATH}/tailscale" "${TSPATH}/tailscaled" /usr/bin
else
	echo "Tailscale is already installed"
fi
