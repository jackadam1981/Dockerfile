#!/bin/sh
docker network create --ipv6 \
--subnet="fc00:0:0:2::/64" \
mynet

# networks:
  # default:
    # external: true
    # name: mynet