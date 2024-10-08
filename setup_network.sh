#!/bin/bash

set -e

OG_DIR=$(pwd)

nodeos --data-dir=/node/data-dir --config-dir=/node --enable-stale-production --genesis-json=/node/genesis.json &

NODEOS_PID=$!

sleep 10

cleos -u http://127.0.0.1:8888 get info

cleos wallet unlock -n devnet --password "PW5Hxdf5mWNSxoWH5UdxPdv9LcsR2hEUFxn1CjLp1NvizzCZ4Cr5i"

cleos create account eosio eosio.token EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.bpay EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.vpay EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.msig EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.names EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.ram EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.ramfee EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.rex EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.saving EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.stake EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.snark EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.goldv EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.agg EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.risc EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6
cleos create account eosio eosio.plonky EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6 EOS5uHeBsURAT6bBXNtvwKtWaiDSDJSdSmc96rHVws5M1qqVCkAm6

curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

echo -e "\n\n\nBUILD: Waiting for protocol feature to activate"
sleep 5
echo -e "\n\n\nBUILD: Setting eosio to eosio.boot contract"
cleos set contract eosio contracts/eosio.boot

echo -e "\n\n\nBUILD: Getting list of supported protocol features and activating them all"
#curl -s http://127.0.0.1:8888/v1/producer/get_supported_protocol_features | jq -r .[].feature_digest | xargs -I {} cleos push action -p eosio@active eosio activate '{"feature_digest":{}}'
curl -s http://127.0.0.1:8888/v1/producer/get_supported_protocol_features | jq -r '.[].feature_digest' | grep -v '0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd' | xargs -I {} cleos push action -p eosio@active eosio activate '{"feature_digest":"{}"}'


echo -e "\n\n\nBUILD: Waiting for protocol features to activate"
sleep 5
cd contracts/eosio.token
echo -e "\n\n\nBUILD: Setting eosio.token contract"
cleos set contract eosio.token . ./eosio.token.wasm ./eosio.token.abi
cd $OG_DIR

echo -e "\n\n\nBUILD: Deploying TLOS token"
cleos push action eosio.token create '["eosio","100000000.0000 TLOS"]' -p eosio.token@active
cleos push action eosio.token issue '["eosio","100000000.0000 TLOS","Issue max supply to eosio"]' -p eosio@active

cd contracts/eosio.system
echo -e "\n\n\nBUILD: Setting eosio to eosio.system contract"
cleos set contract eosio . ./eosio.system.wasm ./eosio.system.abi
cd $OG_DIR

cleos push action eosio init '[0,"4,TLOS"]' -p eosio@active
sleep 6

echo -e "\n\n\nBUILD: Creating Alice account (private key 5KWu5C8FDdNcoCLta3hXuyDKJcxAgaaza3MLkwRJWwEz9C2dn5u)"
cleos system newaccount eosio alice EOS77jzbmLuakAHpm2Q5ew8EL7Y7gGkfSzqJCmCNDDXWEsBP3xnDc EOS77jzbmLuakAHpm2Q5ew8EL7Y7gGkfSzqJCmCNDDXWEsBP3xnDc --stake-net "1000.0000 TLOS" --stake-cpu "1000.0000 TLOS" --buy-ram "5000.0000 TLOS" --transfer
cleos wallet import -n devnet --private-key 5KWu5C8FDdNcoCLta3hXuyDKJcxAgaaza3MLkwRJWwEz9C2dn5u

echo -e "\n\n\nBUILD: Creating Bob account (private key 5JrTaBsS6q6Nt1GJA8r19H8CGg2eHq2oTneZ9md9AhjCEBpLHNJ)"
cleos system newaccount eosio bob EOS6M6T6yDyzjF2ockZQgW7JHx5pGojRdXUHn4qfsqApJinbQj3pd EOS6M6T6yDyzjF2ockZQgW7JHx5pGojRdXUHn4qfsqApJinbQj3pd --stake-net "1000.0000 TLOS" --stake-cpu "1000.0000 TLOS" --buy-ram "5000.0000 TLOS" --transfer
cleos wallet import -n devnet --private-key 5JrTaBsS6q6Nt1GJA8r19H8CGg2eHq2oTneZ9md9AhjCEBpLHNJ

cd contracts/eosio.snarktor_receiver
echo -e "\n\n\nBUILD: Deploying SNARKtor receiver contract"
cleos set contract eosio.snark . ./snarktor_receiver_contract.wasm ./snarktor_receiver_contract.abi
cd $OG_DIR

cd contracts/eosio.snarktor_goldilocks_verifier
echo -e "\n\n\nBUILD: Deploying SNARKtor Goldilocks verifier contract"
cleos set contract eosio.goldv . ./snarktor_goldilocks_verifier_contract.wasm ./snarktor_goldilocks_verifier_contract.abi
cd $OG_DIR

# Give permission to snarktor-receiver-contract to make external inline action
cleos set account permission eosio.snark active --add-code

sleep 5

kill $NODEOS_PID
sleep 10

# Compress the data directory using the -S (sparse) flag to reduce the size of the image
#  It is extracted before starting nodeos in the entrypoint.sh script
cd /node
tar -cSvzf data-dir.tar.gz ./data-dir
rm -rf data-dir
cd $OG_DIR