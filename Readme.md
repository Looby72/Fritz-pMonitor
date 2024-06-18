# FritzBox Network traffic analyzer

This is an automatric network package captureing tool for FritzBoxes. It captures Network packages and analyzes them with ntopng.
This repo is based on the work of Davide Queranta. He created the idea and the initial fritzcap docker image. See his [Blogpost](https://davquar.it/post/self-hosting/ntopng-fritzbox-monitoring/) where he published it.

## Requirements

docker must be installed

## How to use

1. clone the repo
    ```git clone ...```
2. create a .env file in the /fritzcap directory and store the following information into it (seperated by \n):
    - Fritz!Box Username
    - Fritz!Box Password
    - Fritz!Box IP-Adress
    - Display names of the network interfaces you wanna capture
    - URL-Parameters for each network interface you wanna capture (see [this section](#how-to-find-the-url-parameters))
    - IP-Adress range of your local network

    an example .env file could look like:

    ```bash
        FRITZIP=1.1.1.1
        FRITZUSER=user
        FRITZPWD=12345678
        NETWORK_INTERFACES="eth0 eth1 eth2 eth3 ath0 ath1"
        INTERFACE_URL_PARAMS="1-eth0 1-eth1 1-eth2 1-eth3 1-ath0 1-ath1"
        LOCAL_NETWORKS="1.1.1.0/24"
    ```

3. create the virtual network adapter proxy
    ```docker network create proxy```
4. start all docker containers to start capturing
    ```docker compose up```
5. now you can log in to the web interface of ntopng via localhost:80

## How to find the URL Parameters?

todo

## Troubleshooting

- the docker image `ntop/ntopng_arm64.dev:latest` only works for arm systems for all other systems change the image of the ntopng container in /ntopng/dockerfile to `FROM ntop/ntopng:stable`
