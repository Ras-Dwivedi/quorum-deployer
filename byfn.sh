#This file creates a first test network. It is suppose to work like byfn network of Hyperledger Fabric

#source bashrc file to load the environment variable
source ~/.bshrc

#check if QBFT folder exist 
if [[ -d QBFT-Network ]]
then 
	echo "Deleting material from previous deployment"
	rm -rf QBFT-Network
	mkdir QBFT-Network
else 
	mkdir QBFT-Network
fi

cd QBFT-Network
#Replace this via for loop and make number of nodes a variable
mkdir -p Node-0/data/keystore Node-1/data/keystore Node-2/data/keystore Node-3/data/keystore Node-4/data/keystore

#could be commented out
echo "Following directories were created "
tree

#Generating artifacts
npx quorum-genesis-tool --consensus qbft --chainID 1337 --blockperiod 5 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --validators 5 --members 0 --bootnodes 0 --outputPath 'artifacts'

#check whether this command was executed successfully
# You ned to check whether Quorum Genesis Tool was installed

#Need to access folder name before this command could be executed
mv artifacts/2022-02-23-12-34-35/* artifacts

cd artifacts/goQuorum

#Write code to extract keys from static-nodes.json and then change the host name and ports

#write forloop to shift all the files to given directory
cp static-nodes.json genesis.json ../../Node-0/data/
cp static-nodes.json genesis.json ../../Node-1/data/
cp static-nodes.json genesis.json ../../Node-2/data/
cp static-nodes.json genesis.json ../../Node-3/data/
cp static-nodes.json genesis.json ../../Node-4/data/

#Another for loop needed
cd validator0; cp nodekey* address ../../Node-0/data
cd ../validator1; cp nodekey* address ../../Node-1/data
cd ../validator2; cp nodekey* address ../../Node-2/data
cd ../validator3; cp nodekey* address ../../Node-3/data
cd ../validator4; cp nodekey* address ../../Node-4/data

#Another for loop needed
cd ../validator0; cp account* ../../Node-0/data/keystore
cd ../validator1; cp account* ../../Node-1/data/keystore
cd ../validator2; cp account* ../../Node-2/data/keystore
cd ../validator3; cp account* ../../Node-3/data/keystore
cd ../validator4; cp account* ../../Node-4/data/keystore

#Initializing the nodes. Need for another forloop
cd ../../Node-0
geth --datadir data init data/genesis.json
cd ../../Node-1
geth --datadir data init data/genesis.json
cd ../../Node-2
geth --datadir data init data/genesis.json
cd ../../Node-3
geth --datadir data init data/genesis.json
cd ../../Node-4
geth --datadir data init data/genesis.json

#Starting Node 0
#Need another for loop
echo "Starting Node 0"
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
geth --datadir data \
    --networkid 1337 --nodiscover --verbosity 5 \
    --syncmode full \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 22000 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 32000 --ws.origins "*" \
    --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300 &

#Check whether  the command was successfully executed or not and then proceed
echo "Starting Node 1"
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
geth --datadir data \
    --networkid 1337 --nodiscover --verbosity 5 \
    --syncmode full \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 22000 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 32000 --ws.origins "*" \
    --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300 &

echo "Starting Node 2"
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
geth --datadir data \
    --networkid 1337 --nodiscover --verbosity 5 \
    --syncmode full \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 22000 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 32000 --ws.origins "*" \
    --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300 &

echo "Starting Node 3"
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
geth --datadir data \
    --networkid 1337 --nodiscover --verbosity 5 \
    --syncmode full \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 22000 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 32000 --ws.origins "*" \
    --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300 &

echo "Starting Node 4"
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
geth --datadir data \
    --networkid 1337 --nodiscover --verbosity 5 \
    --syncmode full \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 22000 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 32000 --ws.origins "*" \
    --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300 &

#Attaching geth to the node 0
geth attach data/geth.ipc
