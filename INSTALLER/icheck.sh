#prepare MN check script
sudo apt-get update
sudo apt-get install curl -y
cd $HOME
rm -r mncheck.sh
wget https://raw.githubusercontent.com/ultimamirror/ultima/master/INSTALLER/mncheck.sh
chmod +x mncheck.sh

#setup crontab

crontab -l > mycron
echo "*/10 * * * * $HOME/mncheck.sh > /dev/null 2>&1" >> mycron
crontab mycron
rm mycron
