# Starting nodes
N=4
for ((i=0; i<$N; i++))
do 
    echo "Starting Node $i"
    cd ../Node-$i
    echo "present directory is $PWD"
    export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
    export PRIVATE_CONFIG=ignore
    geth --datadir data \
    --networkid 1337 --nodiscover --verbosity 5 \
    --syncmode full \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 0.0.0.0 --http.port 2200$i --http.corsdomain "*" --http.vhosts "*" \
    --graphql --ws --ws.addr 0.0.0.0 --ws.port 3200$i --ws.origins "*" \
    --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 3030$i &
    sleep 5
    disown 

done 