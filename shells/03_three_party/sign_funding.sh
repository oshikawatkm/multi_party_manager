# funding_tx: accounts[0].funding_tx.tx.to_payload.bth

tx="0100000003cf0f16ed2cdead02d33de64518483ff263fa4c2c9cb025ef7a583ca2cb4d9abe0000000000ffffffffe29f8fc9d4790e0b9b8665b92c33e0dfc7be546de711d609778e1fb4d7d400100100000000ffffffffe33f748e5ad7aed7854ec005138eaa85e16d88d58beb74d929d2ecf55229d5df0000000000ffffffff04584d000000000000160014ed2b4ea67faf5c55c81961ad83b0a2432f9d28ac584d0000000000001600143cf365223f20426134ac8fcfecaf8fe3fbce867b584d0000000000001600141cafa7db65d1a6a1a09ec00319f741ac5eb3c18c3075000000000000220020933577451d79e9e603810330da4a7ebe7f3611f2bfd2e81cb9a89732376fd5e200000000"

tx=$(bitcoin-cli -rpcwallet=wokashiwallet -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wallet2 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wallet3 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')

echo $tx
echo "bitcoin-cli -rpcwallet=wokashiwallet decoderawtransaction "
echo "bitcoin-cli -rpcwallet=wokashiwallet  -named sendrawtransaction hexstring="