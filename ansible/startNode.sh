#source bash profile
source ~/.bash_profile
source ~/.bashrc
source ~/.profile


# # initializing the nodes.
cd ~/rasdwivedi/ansible_blockchain/quorum/Node
echo "installing node"
geth --datadir data init data/genesis.json

# Starting nodes
echo "Starting Node"
echo "present directory is $PWD"
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
geth --datadir data \
--networkid 1337 --nodiscover --verbosity 5 \
--syncmode full \
--raft --raftport 53000 --raftblocktime 300 --emitcheckpoints \
--http --http.addr 0.0.0.0 --http.port 22001 --http.corsdomain "*" --http.vhosts "*" \
--graphql --ws --ws.addr 0.0.0.0 --ws.port 32001 --ws.origins "*" \
--http.api admin,eth,debug,miner,net,txpool,personal,web3,raft \
--ws.api admin,eth,debug,miner,net,txpool,personal,web3,raft \
--unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
--port 30303 &
disown