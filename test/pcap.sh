#!/bin/bash

# create a fifo pipe filled with test data
rm -f pcap/*
mkfifo pcap/testFifo
echo "creating test pipe"
cat testData.pcap > pcap/testFifo