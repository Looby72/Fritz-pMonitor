#!/bin/bash

SIDFILE="/tmp/fritz.sid"

if [ -z "$FRITZIP" ] || [ -z "$FRITZPWD" ] || [ -z "$FRITZUSER" ] ; then echo "FRITZUSER, FRITZPWD, FRITZIP must all be set" ; exit 1; fi

echo "Logging in as $FRITZUSER into Fritz!Box $FRITZIP"

if [ ! -f $SIDFILE ]; then
  touch $SIDFILE
fi

SID=$(cat $SIDFILE)

# Request challenge token from Fritz!Box
CHALLENGE=$(curl -k -s $FRITZIP/login_sid.lua | grep -o "<Challenge>[a-z0-9]\{8\}" | cut -d'>' -f 2)

# Very proprietary way of AVM: create an authentication token by hashing the challenge token with the password
HASH=$(perl -MPOSIX -e '
    use Digest::MD5 "md5_hex";
    my $ch_Pw = "$ARGV[0]-$ARGV[1]";
    $ch_Pw =~ s/(.)/$1 . chr(0)/eg;
    my $md5 = lc(md5_hex($ch_Pw));
    print $md5;
  ' -- "$CHALLENGE" "$FRITZPWD")
  curl -k -s "$FRITZIP/login_sid.lua" -d "response=$CHALLENGE-$HASH" -d 'username='${FRITZUSER} | grep -o "<SID>[a-z0-9]\{16\}" | cut -d'>' -f 2 > $SIDFILE

SID=$(cat $SIDFILE)

# Check for successfull authentication
if [[ $SID =~ ^0+$ ]] ; then echo "Login failed. Did you create & use explicit Fritz!Box users?" ; exit 1 ; fi

echo "Login successful"

rm -f pcap/*

# read .env vars
read -a NETWORK_INTERFACES <<< $NETWORK_INTERFACES
read -a INTERFACE_URL_PARAMS <<< $INTERFACE_URL_PARAMS

# create FIFOs for each network interface and start packet capture by sending HTTP-request to Fritz!Box
for index in ${!NETWORK_INTERFACES[*]}
do
  INTERFACE=${NETWORK_INTERFACES[$index]}
  PARAM=${INTERFACE_URL_PARAMS[$index]}
  echo "Creating pipe $INTERFACE"
  mkfifo pcap/$INTERFACE
  echo "Starting packet capture on pipe $INTERFACE"
  wget --no-check-certificate -qO- $FRITZIP/cgi-bin/capture_notimeout?ifaceorminor=$PARAM\&snaplen=\&capture=Start\&sid=$SID > "pcap/$INTERFACE" &
done

echo "Capturing... (barrier reached)"

wait $(jobs -p)
echo "All packet capture jobs have been interrupted"