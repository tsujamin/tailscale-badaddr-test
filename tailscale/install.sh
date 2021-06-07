#! /bin/sh
set -eu

echo "ARGS: $@"

BUILD_ARCH="$1"
TAILSCALE_VERSION="$2"

echo "Downloading tailscale $TAILSCALE_VERSION for $BUILD_ARCH"

# Convert hass arch to tailscale
case "$BUILD_ARCH" in
    "armhf" | "armv7")
        TAILSCALE_ARCH="arm"
    ;;
    "aarch64")
        TAILSCALE_ARCH="arm64"
    ;;
    "amd64")
        TAILSCALE_ARCH="amd64"
    ;;
    "i386")
        TAILSCALE_ARCH="386"
    ;;
esac

echo "ifconfig"
ifconfig

echo "dns"
host pkgs.tailscale.com

echo "ipv4"
curl -v http://ipv4.tlund.se/ | grep '<title>' || echo "ipv4 failed"

echo "ipv6"
curl -v http://ipv6.tlund.se/ | grep '<title>' || echo "ipv6 failed"

echo "dual"
curl -v http://dual.tlund.se/ | grep '<title>' || echo "dual failed"

wget --prefer-family=IPv4 "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_${TAILSCALE_ARCH}.tgz" -O - | tar xzf -
mv "tailscale_${TAILSCALE_VERSION}_${TAILSCALE_ARCH}"/tailscale* /bin
rm -rf "tailscale_${TAILSCALE_VERSION}_${TAILSCALE_ARCH}"
