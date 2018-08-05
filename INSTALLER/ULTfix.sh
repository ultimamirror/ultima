#!/bin/bash
#Script version 1.1

#Stop ultima processes
clear
/bin/echo -e "\e[33mStopping ultima processes...\e[0m"
killall ultimad
sleep 5
echo "Done"

#Delete all ultima files except configs & wallet
echo "" && /bin/echo -e "\e[33mDeleting ultima blockchain...\e[0m"
shopt -s extglob
cd ~/.ultimacore
rm -rfv !("ultima.conf"|"masternode.conf"|"wallet.dat")

#Start ultima process
echo "" && /bin/echo -e "\e[33mRestarting ultima daemon...\e[0m"
/usr/local/bin/ultimad -daemon
sleep 5

#Synchronize blockchain
echo "" && /bin/echo -e "\e[33mPlease wait, initializing masternode sync...\e[0m"
until su -c "/usr/local/bin/ultima-cli masternode status 2>/dev/null | grep 'NEW_START' > /dev/null"; do
	#Display percent complete
    sleep 10
	BLOCK_COUNT=$(curl -s https://ult.overemo.com/api/getblockcount)
	CURRENT_BLOCK=$(/usr/local/bin/ultima-cli getblockcount)
	PERCENT=$(awk -v a=$BLOCK_COUNT -v b=$CURRENT_BLOCK 'BEGIN { print (b / a)*100 }')
	if [ ! -z "$BLOCK_COUNT" ]; then
		if (("$CURRENT_BLOCK" > 0)); then
			clear
			/bin/echo -e "\e[33mPlease wait, synchronizing masternode...\e[0m" && echo $PERCENT" %"
		fi
	fi
done

#Wait for masternode start
clear
/bin/echo -e "Masternode synchronized: \e[33mplease start your masternode in the wallet\e[0m" && echo "" && echo "Waiting for masternode start.."
until su -c "/usr/local/bin/ultima-cli masternode status 2>/dev/null | grep 'successfully started' > /dev/null"; do
    sleep 5
done

#Complete
clear
/bin/echo -e "\e[92mMasternode maintenance complete!\e[0m" && echo ""
