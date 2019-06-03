read -p 'Enter your masternode genkey you created in windows, then hit [ENTER]: ' GENKEY
apt-add-repository ppa:bitcoin/bitcoin -y
apt-get update
apt-get install -y htop libboost-all-dev libzmq3-dev \
libdb4.8-dev libdb4.8++-dev libevent-dev \
libssl-doc zlib1g-dev fail2ban


ufw default allow outgoing && \
ufw default deny incoming && \
ufw allow ssh/tcp && \
ufw limit ssh/tcp && \
ufw allow 10111/tcp && \
ufw allow 61472/tcp && \
ufw allow 61317/tcp && \
ufw allow 13058/tcp && \
ufw logging on && \
ufw --force enable


systemctl enable fail2ban && \
systemctl start fail2ban

wget https://github.com/GIN-coin/gincoin-core/releases/download/v1.2.1.0/gincoin-binaries-1.2.1-linux-64bit.tar.gz
tar -zxvf gincoin-binaries-1.2.1-linux-64bit.tar.gz
mkdir -p .gincoincore
cat <<EOT >> .gincoincore/gincoin.conf
rpcuser=gincoin
rpcpassword=gincoin
rpcallowip=127.0.0.1
rpcthreads=8
listen=1
server=1
discover=1
daemon=1
txindex=1
externalip={IP}:10111
masternode=1
masternodeprivkey={PK}
EOT
IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
sed -i -e "s/{IP}/$IP/g" .gincoincore/gincoin.conf

sed -i -e "s/{PK}/$GENKEY/g" .gincoincore/gincoin.conf


~/gincoin-binaries/gincoind


