#!/usr/bin/env bats

@test "downloads and installs tailscale" {
	env \
		VERSION=1.24.2 \
		./src/scripts/download.sh

	test -x /usr/bin/tailscale
	test -x /usr/bin/tailscaled
}
