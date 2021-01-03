# funding_tx: accounts[0].funding_tx.tx.to_payload.bth

tx="0100000004e9b953a9b42d5bb70c13226fe99586243c1f22ca6cdda573bd94067d17cdb87d0000000000ffffffffda5f95f3737a0a888019389132f98d67011f9e1f8310143e5ae474a6dfdcdce90000000000ffffffffb3976529a8f14f4db107e1e6dc18ea8e0dd7c9f36b6ab3c2d90d79364c0f797f0100000000ffffffff9c316575c8d3c90eba6e561a7235a6060bdd2d55c5cc393fcaf7779c16cdd6360000000000ffffffff05f087000000000000160014890b076a2e1284f560765829d3fe99b9ced6a957584d0000000000001600145dbdf10521c41b73b8c91014adadcbb28c80525e584d00000000000016001432b05f3611c37f08faa39184bde675ad639ca7dd0be90000000000001600142e148fdc684b9b06f808bb944005ffa0bb16d74c409c0000000000002200208ff129b1c4f62edababc2a9c469de57a110d4cf4946c80d77c557f6ffeb373d300000000"

tx=$(bitcoin-cli -rpcwallet=wokashiwallet -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wallet2 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wallet3 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')
tx=$(bitcoin-cli -rpcwallet=wokashi4 -named signrawtransactionwithwallet hexstring=$tx | jq -r '.hex')

echo $tx
echo "bitcoin-cli -rpcwallet=wokashiwallet decoderawtransaction "
echo "bitcoin-cli -rpcwallet=wokashiwallet  -named sendrawtransaction hexstring="