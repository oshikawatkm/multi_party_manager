
tx="010000000138821713d5fd1085e83389f21f53e10a5dabb0860261906a3af06c2983c1b3c80400000000ffffffff04f82a0000000000001600145dbdf10521c41b73b8c91014adadcbb28c80525e102700000000000016001432b05f3611c37f08faa39184bde675ad639ca7dd9411000000000000220020f03987a3faa50114f669543cb64da3d22d15a7b8a2bff77d850b5c52b78780d3941100000000000022002015cb118f8bbe7cdc09bd2761170177b663e0744bce70c7dcbb95c46c1889a96b00000000"

prev_txid="c8b3c183296cf03a6a90610286b0ab5d0ae1531ff28933e88510fdd513178238"
funding_redeem_script="53148911455a265235b2d356a1324af000d4dae03262148911455a265235b2d356a1324af000d4dae03262148911455a265235b2d356a1324af000d4dae0326253ae"
prev_spk="0020f06c4305211079f9bb5c2cdfb55b452f0ccc106f4abab0b0e4e3f9da2657b0ee"

privkey1="cVy1Pu3YZunxgBNMVqiCiYKcdCwjjXdx2uVNiXxXbNJ2A6oujmKU"


bitcoin-cli -rpcwallet=wokashiwallet signrawtransactionwithkey hexstring=$tx prevtxs='''[ { "txid": "'$prev_txid'", "vout": 3, "scriptPubKey": "", "redeemScript": "", "witnessScript":"'$funding_redeem_script'" } ]''' privkeys='''["'$privkey1'"]'''


bitcoin-cli -rpcwallet=wokashiwallet signrawtransactionwithwallet "'$tx'" [ { "txid": "'$prev_txid'", "vout": 3, "scriptPubKey": "", "redeemScript": "", "witnessScript":"'$funding_redeem_script'" } ]