# Fritz-pMonitor: Fritz!Box Network Traffic Analyzer

Fritz-pMonitor is an automated tool designed for capturing and analyzing network packets on Fritz!Box routers. It captures network traffic on selected network interfaces and analyzes it using ntopng. This repository builds upon the foundational work of Davide Queranta, who conceptualized and created the initial fritzcap Docker image. For more information, see his [blog post](https://davquar.it/post/self-hosting/ntopng-fritzbox-monitoring/) where he introduced the project.

## Requirements

docker must be installed

## How to use

1. clone the repo
    ```git clone git@github.com:Looby72/Fritz-pMonitor.git```
2. create a .env file in the Fritz-pMonitor directory and store the following information into it (seperated by \n):
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
