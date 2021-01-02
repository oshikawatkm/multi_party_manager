# funding_tx: accounts[0].funding_tx.tx.to_payload.bth

tx="010000000138821713d5fd1085e83389f21f53e10a5dabb0860261906a3af06c2983c1b3c80300000000ffffffff04f82a0000000000001600145dbdf10521c41b73b8c91014adadcbb28c80525e102700000000000016001432b05f3611c37f08faa39184bde675ad639ca7dd94110000000000002200207c0ffad1947b61952b6339614e894da9e9725b86c5020e7a8c9329d741b1406294110000000000002200203904b92b2794a39c90e111fdad2fdeb7dc997c328d6b19e86218bdb4b139a72900000000"

tx=$(bitcoin-cli -rpcwallet=wokashiwallet -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wallet2 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wallet3 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')

echo $tx
echo "bitcoin-cli -rpcwallet=wokashiwallet decoderawtransaction "
echo "bitcoin-cli -rpcwallet=wokashiwallet  -named sendrawtransaction hexstring="