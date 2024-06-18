#!/bin/bash

# read interfaces from .env
read -a NETWORK_INTERFACES <<< $NETWORK_INTERFACES

# create command line args
CMD_ARGS=""
for index in ${!NETWORK_INTERFACES[*]}
do
  INTERFACE=${NETWORK_INTERFACES[$index]}
  CMD_ARGS="$CMD_ARGS -i pcap/$INTERFACE"
done

CMD_ARGS="$CMD_ARGS --local-networks=\"$LOCAL_NETWORKS\" --community"

# start redis and ntopng
/etc/init.d/redis-server start
ntopng "$@" $NTOP_CONFIG $CMD_ARGS