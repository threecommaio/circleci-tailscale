# CircleCI Orb for using Tailscale

Orb: https://circleci.com/developer/orbs/orb/threecomma/circleci-tailscale


## Quick Start Guide
Use CircleCI version 2.1 at the top of your `.circleci/config.yml` file.
```
version: 2.1
```
If you do not already have Pipelines enabled, you'll need to go to Project Settings -> Advanced Settings and turn it on.

Add the orbs stanza below your version, invoking the orb:
```
orbs:
  circleci-tailscale: threecomma/circleci-tailscale@1.0.0
```


1. Goto the [Tailscale Admin Console](https://login.tailscale.com/admin/settings/authkeys) and create a new `Auth Key`. Select `Ephemeral Key`

> *Ephemeral Keys* do not associate an IPv4 address, only IPv6. This means if you use this type, the machine you are trying to hit must have IPv6 enabled. It's recommended that you use Magic DNS, as it will resolve the AAAA record (IPv6) automatically if you try to address the machine through tools like `curl`

2. Create an environment variable in your project: `TAILSCALE_AUTH_KEY` and paste the new key you created.

3. The orb automatically exposes environment variables: `[http_proxy,https_proxy,ALL_PROXY,HTTP_PROXY,HTTPS_PROXY]` that populates to `socks5h://localhost:1055/`.

This makes it compatible with various applications like `curl` that respect these environment variables to proxy through a socks5 proxy.

> The reason we use `socks5h` is to force DNS resolution through the socks5 proxy that is setup with Tailscale.

## Sample workflow in CircleCI
Here is a sample `.circleci/config.yml`
If you would like to change the tailscale version you can set the parameter `tailscale-version`.

> *WARNING*: Tailscale versions < 1.15.116 did not handle build environments such as CircleCI correctly. [Issue #2827](https://github.com/tailscale/tailscale/issues/2827) resolves this bug.

```yaml
version: 2.1

orbs:
  circleci-tailscale: threecomma/circleci-tailscale@1.0.0

jobs:
  build:
    docker:
      - image: circleci/node:fermium-stretch
    parameters:
      tailscale-auth-key:
        type: env_var_name
        default: TAILSCALE_AUTH_KEY
    steps:
      - checkout
      - circleci-tailscale/connect
      - run:
          name: curl a tailscale machine over port 8080
          command: |
             until curl "http://[machine].[namespace].beta.tailscale.net:8080/"
             do
              sleep 1
             done
```

## Parameters
| Parameter          | Description                                              | Default Value |
|--------------------|----------------------------------------------------------|---------------|
| tailscale-auth-key | Your Tailscale authentication key, from the admin panel. |               |
| tailscale-version  | Tailscale version to use.                                |     1.15.116  |