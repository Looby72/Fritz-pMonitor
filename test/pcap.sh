#!/bin/bash

# create a fifo pipe filled with test data
rm -f pcap/*
mkfifo pcap/testFifo

FILE="test_data.pcap"
if [ ! -f "$FILE" ]; then
    # download test pcap data
    echo "Downloading $FILE ..."
    wget -q -O "${FILE}.gz" "https://share.netresec.com/s/wC4mqF2HNso4Ten/download?path=%2F&files=maccdc2010_00000_20100310205651.pcap.gz&downloadStartSecret=fprppure7s"
    gunzip "${FILE}.gz"
else
    echo "File $FILE already exists."
fi
echo "creating test pipe"
cat test_data.pcap > pcap/testFifo