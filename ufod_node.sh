echo This script transforms your raspbian installation to a working ufocoin client.
echo ufod will be installed in /usr/local/bin/
echo The blockchain, chainstate and conf files will be installed in /home/pi/.ufo
echo press enter to continue, or ctrl c to quit...
read whatever


echo
echo updating software...
echo
sudo apt-get -y update
sudo apt-get -y upgrade
echo
echo installing ufw firewall...
echo

sudo apt-get -y install ufw

echo disabling ipv6 in ufw...
sudo cat /etc/default/ufw > ufw
sed -i '/IPV6=/d' ufw
echo "IPV6=no" >> ufw
sudo mv -f ufw /etc/default/ufw
sudo chmod 644 /etc/default/ufw
sudo chown root:root /etc/default/ufw 

echo configuring ufw...
echo Opening up Port 22 TCP for SSH
sudo ufw allow 22/tcp
echo opening up Port 9887 for UFOcoin
sudo ufw allow 9887/tcp
sudo ufw status verbose
sudo ufw --force enable

echo
echo installing dependencies for UFOcoin...
echo
sudo apt-get -y install build-essential libtool autotools-dev automake pkg-config libevent-dev bsdmainutils libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libminiupnpc-dev git g++ g++-4.6
echo



cd /home/pi
mkdir .ufo

echo
echo downloading source files...
echo
sudo git clone https://github.com/UFOCoins/ufo.git
cd ufo
echo
echo compiling... this takes some hours...
echo
sudo ./autogen.sh
sudo ./configure
sudo make
echo Installing UFOd in /usr/local/bin
sudo cp -f /home/pi/ufo/src/ufod /usr/local/bin
sudo cp -f /home/pi/ufo/src/ufo-cli /usr/local/bin
sudo cp -f /home/pi/ufo/src/ufo-tx /usr/local/bin

echo
echo Removing source files...
echo
sudo rm -rf /home/pi/ufo

cd /home/pi

echo
echo Setting up ufod conf file
echo
echo "# ufo.conf" > .ufo/ufocoin.conf
echo "# JSON-RPC options for controlling a running ufod process" >> .ufo/ufocoin.conf
echo "# Server mode allows ufod to accept JSON-RPC commands" >> .ufo/ufocoin.conf
echo "# You must set rpcuser and rpcpassword to secure the JSON-RPC api" >> .ufo/ufocoin.conf
echo "rpcusername=user10298357" >> .ufo/ufocoin.conf

echo Enter a long random password for rpc. This should NOT be your wallet password.
echo You wont need this password for normal use, so make it long and difficult.
echo You can change it anytime by editting ufo.conf in /home/pi./ufo
read rpcpassword

echo "rpcpassword=$rpcpassword" >> .ufo/ufocoin.conf
echo "server=1" >> ~/.ufo/ufocoin.conf

echo moving start script for ufod to /etc/init.d
sudo mv /home/pi/UFO_RaspBerry_Pi_Full_Node/ufocoin /etc/init.d
cd /etc/init.d
sudo chmod 755 ufocoin

sudo update-rc.d ufocoin defaults

cd /home/pi/.ufo

echo thats you all set up just sudo reboot to restart your pi, give it a few minutes after booting for the ufod daemon to start up and your off and running






