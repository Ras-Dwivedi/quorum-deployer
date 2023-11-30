#This file creates a first test network. It is suppose to work like byfn network of Hyperledger Fabric
# This file is used for the multinode deployment
# This scripts first create the crypto data needed for the nodes, and then called the ansible script to deploy all the data to the relevant machines
#Parameters
read -p 'number of nodes: ' N
#
##source bashrc file to load the environment variable
source ~/.bash_profile
source ~/.bashrc
source ~/.profile
#
echo "checking versions"
echo node -v
echo go version 
if [["$(node -v)" < "v16"]];
then
    echo "Please use the latest node version. ......Exiting"
    exit 0
else
     echo "node version installed is " 
     node -v
fi
if [ $? -eq 0 ]; then
  echo "All pre-requisite found"
else
  echo "unable to found pre-requisite.... exiting "
  exit 0
fi

echo "creating directory structure"
##exit 0
##Clean the previous deployment
if [[ -d QBFT-Network ]]
then 
	echo "Deleting material from previous deployment"
	rm -rf QBFT-Network
	mkdir QBFT-Network
else 
	mkdir QBFT-Network
fi
#
cd QBFT-Network
#
#Create directory structure
for ((i=0; i<$N; i++))
do 
   mkdir -p Node-$i/data/keystore
done 
#
#List the directory structure
echo "Following directories were created "
tree

#Generating artifacts
npx quorum-genesis-tool --consensus qbft --chainID 1337 --blockperiod 5 --requestTimeout 400 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --validators $N --members 0 --bootnodes 0 --outputPath 'artifacts'

# #check whether this command was executed successfully
if [ $? -eq 0 ]; then
  echo OK
else
  echo "unable to generated artifacts .... exiting "
  exit 0
fi
#
#moving artifacts
mv artifacts/$(ls artifacts)/* artifacts/

echo "current directory structure"
tree

#Update IP and ports
cd artifacts/goQuorum

#Update IP and the port number
echo $PWD
inventory_file="../../../ansible/inventory.ini"  # Replace with the actual path to your inventory file

# Extract IP addresses using grep
ip_addresses=$(grep -Eo 'ansible_host=[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' $inventory_file | cut -d= -f2)

# Print the IP addresses
echo "IP Addresses:"
echo "$ip_addresses"
# Path to the static-nodes.json file
json_file="static-nodes.json"  # Replace with the actual path to your JSON file

# Loop through each IP address and replace <HOST> in the i+2th line
i=1
for ip_address in $ip_addresses; do
    sed -i "$((i+1)) s/<HOST>/$ip_address/" $json_file
    ((i++))
done
cat $json_file

# ------------

# #update IP and port number
# for ((i=0; i<$N; i++))
# do 
#    echo "----------- for $i ------------"    
#    sed -i "$((i+2)) s/<HOST>/127.0.0.1/" static-nodes.json
#   #  sed -i "$((i+2)) s/30303/3030$i/" static-nodes.json
#   #  sed -i "$((i+2)) s/53000/5300$i/" static-nodes.json

# done 

# echo "updated static node file"
# cat static-nodes.json
# echo "not using permissioned node "
#
# #write forloop to shift all the files to given directory
# N=5
# cd QBFT-Network/artifacts/goQuorum
# echo "in go Quorum"
# echo "directories"
echo "displaying director structure. Currently in directory $PWD"
tree
sleep 5

echo "setting empty block time period to 300"
sed -i 's/"emptyblockperiodseconds": 60/"emptyblockperiodseconds": 300/g' genesis.json

for ((i=0; i<$N; i++))
do 
    echo "Shifting genesis file"
    cp static-nodes.json genesis.json ../../Node-$i/data/
done 
cd ..
#in goQuorum folder
echo "currently in folder $PWD"
sleep 5

echo "tree here is" 
tree

for ((i=0; i<$N; i++))
do 
    echo "Moving node data"
    cd validator$i
    cp nodekey* address ../../Node-$i/data
    cd ..
    ls
done 

cd validator0
echo "Changed to the validator0 directory. Currently in directory $PWD"
for ((i=0; i<$N; i++))
do 
   echo "copying data keystore"
   cd ../validator$i
   cp account* ../../Node-$i/data/keystore
done 

if [ $? -eq 0 ]; then
  echo "successfully moved validator directory "
else
  echo "unable to move Validator directory .... exiting "
  exit 0
fi
# Move to the ansible directory
echo $PWD
cd ../../../ansible
echo $PWD
# # initializing the nodes.
# cd ../../Node-0
# for ((i=0; i<$N; i++))
# do 
#     echo "installing node $i"
#     cd ../Node-$i
#     geth --datadir data init data/genesis.json
# done 

# Starting nodes
# for ((i=0; i<$N; i++))
# do 
#     echo "Starting Node $i"
#     cd ../Node-$i
#     echo "present directory is $PWD"
#     export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
#     export PRIVATE_CONFIG=ignore
#     geth --datadir data \
#     --networkid 1337 --nodiscover --verbosity 5 \
#     --syncmode full \
#     --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
#     --http --http.addr 0.0.0.0 --http.port 2200$i --http.corsdomain "*" --http.vhosts "*" \
#     --graphql --ws --ws.addr 0.0.0.0 --ws.port 3200$i --ws.origins "*" \
#     --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
#     --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
#     --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
#     --port 3030$i &
#     sleep 5
#     disown 

# done 

echo "Deploying blockchain on each of the nodes"
ansible-playbook -i inventory.ini playbook.yml
if [ $? -eq 0 ]; then
  echo "Blockhain nodes on all server started"
else
  echo "Error from atleast one of the server..... Exiting "
  exit 0
fi