#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME

CHEIGHT=$(curl https://ult.overemo.com/api/getblockcount)
VPSHEIGHT=$(ultima-cli getblockcount)

if [[ $(($VPSHEIGHT + 10)) < $CHEIGHT ]] && ultima-cli mnsync status | grep -m 1 '"IsBlockchainSynced": true'
then
ultima-cli stop
sleep 5
rm -r $HOME/.ultimacore/{blocks,database,db.log,debug.log,fee_estimates.dat,netfulfilled.dat,ultimad.pid,chainstate,mncache.dat,mnpayments.dat,governance.dat,banlist.dat,peers.dat,backups}
sleep 5
ultimad -daemon -reindex
fi
