
# txhex: accounts[0].commitment_txs[2].tx.to_payload.bth
# prev_txid:  accounts[0].funding_tx.tx.
# funding_redeem_script: accounts[0].funding_tx.redeem_script.to_payload.bth
# prev_spk: accounts[0].funding_tx.tx.out[3].pk_script.bth



tx="010000000138821713d5fd1085e83389f21f53e10a5dabb0860261906a3af06c2983c1b3c80400000000ffffffff04f82a0000000000001600145dbdf10521c41b73b8c91014adadcbb28c80525e102700000000000016001432b05f3611c37f08faa39184bde675ad639ca7dd9411000000000000220020f03987a3faa50114f669543cb64da3d22d15a7b8a2bff77d850b5c52b78780d3941100000000000022002015cb118f8bbe7cdc09bd2761170177b663e0744bce70c7dcbb95c46c1889a96b00000000"
prev_txid="c8b3c183296cf03a6a90610286b0ab5d0ae1531ff28933e88510fdd513178238"
funding_redeem_script="53148911455a265235b2d356a1324af000d4dae03262148911455a265235b2d356a1324af000d4dae03262148911455a265235b2d356a1324af000d4dae0326253ae"
prev_spk="0020f06c4305211079f9bb5c2cdfb55b452f0ccc106f4abab0b0e4e3f9da2657b0ee"

privkey1="cVy1Pu3YZunxgBNMVqiCiYKcdCwjjXdx2uVNiXxXbNJ2A6oujmKU"
privkey2="cPgjjjfmiAP9yiKqNK4EYCbJo2JUbS4WfAceUPj7Hz5vC1cRWqf8"
privkey3="cUEC5nAFkqorqEnyHbCkMpUd9gHecroghS8AvPyJE3wArfenSfHc"

txhex=$(bitcoin-cli -rpcwallet=wokashiwallet -named signrawtransactionwithkey hexstring=$tx prevtxs='''[ { "txid": "'$prev_txid'", "vout": 3, "scriptPubKey": "'$prev_spk'", "redeemScript": "'$funding_redeem_script'" } ]''' privkeys='''["'$privkey1'"]''' | jq -r '.hex')

txhex=$(bitcoin-cli -rpcwallet=wallet2 -named signrawtransactionwithkey hexstring=$txhex prevtxs='''[ { "txid": "'$prev_txid'", "vout": 3, "scriptPubKey": "'$prev_spk'", "redeemScript": "'$funding_redeem_script'" } ]''' privkeys='''["'$privkey2'"]''' | jq -r '.hex')

txhex=$(bitcoin-cli -rpcwallet=wallet3 -named signrawtransactionwithkey hexstring=$txhex prevtxs='''[ { "txid": "'$prev_txid'", "vout": 3, "scriptPubKey": "'$prev_spk'", "redeemScript": "'$funding_redeem_script'" } ]''' privkeys='''["'$privkey3'"]''' | jq -r '.hex')

echo $txhex
echo "bitcoin-cli -rpcwallet=wokashiwallet decoderawtransaction "
echo "bitcoin-cli -rpcwallet=wokashiwallet  -named sendrawtransaction hexstring="