#Required packages
NONE='\033[00m'
GREEN='\033[01;32m'

echo -e "${GREEN}* Installing packages and updates...${NONE}";

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install git -y
sudo apt-get install nano -y
sudo apt-get install build-essential libtool automake autoconf -y
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libdb5.3-dev libdb5.3++-dev -y

echo -e "${GREEN}* Packages installed.${NONE}";

#Ultima client

echo -e "${GREEN}* Downloading Ultima client...${NONE}";

wget https://github.com/ultimamirror/ultima/releases/download/0.12.1.1/ultima-0.12.1.1.tar.gz
sudo mkdir $HOME/ultima-0.12.1.1
tar -zxvf ultima_linux.tar.gz -C $HOME/ultima-0.12.1.1
sudo cp $HOME/ultima-0.12.1.1/compiled/ultimad /usr/local/bin/
sudo cp $HOME/ultima-0.12.1.1/compiled/ultima-cli /usr/local/bin/

#Config

echo -e "${GREEN}* Please paste your genkey by clicking right mouse button, then confirm with enter${NONE}";
read GENKEY

echo -e "${GREEN}* Setting up config file...${NONE}";

sudo apt-get install -y pwgen
EXTERNALIP=`wget -qO- eth0.me`
PASSWORD=`pwgen -1 20 -n`
sudo mkdir $HOME/.ultimacore
printf "rpcuser=ultimauser\nrpcpassword=$PASSWORD\nrpcallowip=127.0.0.1\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=256\nrpcport=8421\nexternalip=$EXTERNALIP:8420\nmasternodeprivkey=$GENKEY\nmasternode=1\naddnode=5.189.130.112:8420\naddnode=89.207.129.52:8420\naddnode=104.156.253.128:8420\naddnode=37.59.197.128:8420\naddnode=185.243.131.22:8420\naddnode=140.82.57.217:8420\naddnode=207.148.97.178:8420\naddnode=54.163.55.167:8420\naddnode=176.114.6.132:8420\naddnode=37.59.197.155:8420\naddnode=45.63.87.73:8420\naddnode=5.9.178.147:8420\naddnode=98.100.196.186:8420\naddnode=45.63.62.19:8420\naddnode=172.245.162.115:8420\naddnode=5.9.178.158:8420\naddnode=144.202.125.219:8420\naddnode=45.63.117.235:8420\naddnode=45.76.94.159:8420\naddnode=108.61.57.104:8420\naddnode=79.1.180.166:8420\naddnode=176.114.6.48:8420\naddnode=91.234.34.167:8420\naddnode=144.202.104.169:8420\naddnode=94.156.174.74:8420\naddnode=45.76.215.150:8420\naddnode=140.82.56.103:8420\naddnode=83.128.86.198:8420\naddnode=45.77.235.28:8420\naddnode=199.247.15.21:8420\naddnode=140.82.57.51:8420\naddnode=167.99.154.208:8420\naddnode=198.13.56.161:8420\naddnode=45.76.182.7:8420\naddnode=142.44.241.161:8420\naddnode=5.196.189.89:8420\naddnode=5.9.247.73:8420\naddnode=94.156.174.26:8420\naddnode=37.59.197.147:8420\naddnode=94.156.174.30:8420\naddnode=78.46.30.27:8420\naddnode=78.47.164.82:8420\naddnode=94.156.174.68:8420\naddnode=185.203.118.190:8420\naddnode=94.156.174.22:8420\naddnode=46.165.246.232:8420" > /$HOME/.ultimacore/ultima.conf

echo -e "${GREEN}* Starting client...${NONE}";
ultimad --daemon
echo -e "[12/${MAX}] Waiting for sync, it may take some time...${NONE}";
until ultima-cli mnsync status | grep -m 1 '"IsBlockchainSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Blockchain Synced${NONE}";
until ultima-cli mnsync status | grep -m 1 '"IsMasternodeListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Masternode List Synced${NONE}";
until ultima-cli mnsync status | grep -m 1 '"IsWinnersListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Winners List Synced${NONE}";
until ultima-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Done sync${NONE}";

wget https://raw.githubusercontent.com/ultimamirror/ultima/master/INSTALLER/ULTfix.sh
chmod +x ULTfix
sudo mv ULTfix.sh /usr/local/bin

wget https://raw.githubusercontent.com/ultimamirror/ultima/master/INSTALLER/icheck.sh
chmod +x icheck.sh
./icheck.sh

sleep 5
echo -e "${GREEN}* Your VPS ip for masternode.conf: $EXTERNALIP:8420${NONE}";
