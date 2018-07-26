#prepare MN check script
sudo apt-get update
sudo apt-get install curl -y
cd $HOME
rm -r mncheck.sh
wget http://ultima.qa/mncheck.sh
chmod +x mncheck.sh

#setup crontab

crontab -l > mycron
echo "*/20 * * * * $HOME/mncheck.sh > /dev/null 2>&1" >> mycron
crontab mycron
rm mycron