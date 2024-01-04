#!/bin/bash

cd
curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
sudo apt-get install speedtest

echo "TERMINÉ"
#speedtest
#speedtest -L
#speedtest -s 12746
#speedtest --selection-details


#-----------------Speed test CLI -------------
#cd
#sudo apt-get update
#sudo apt-get install python
#wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
#chmod +x speedtest-cli
#./speedtest-cli -h



#./speedtest-cli --list
#./speedtest-cli --csv
