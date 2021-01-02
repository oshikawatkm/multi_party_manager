echo "Account1"
bitcoin-cli -rpcwallet=wokashiwallet listunspent
echo "===================================================="
echo "Account2"
bitcoin-cli -rpcwallet=wallet2 listunspent
echo "===================================================="
echo "Account3"
bitcoin-cli -rpcwallet=wallet3 listunspent
echo "===================================================="
echo "Account4"
bitcoin-cli -rpcwallet=wokashi4 listunspent
echo "===================================================="


echo "bitcoin-cli -rpcwallet=wokashiwallet gettransaction "
echo "bitcoin-cli -rpcwallet=wallet2 gettransaction "
echo "bitcoin-cli -rpcwallet=wallet3 gettransaction "
echo "bitcoin-cli -rpcwallet=wokashi4 gettransaction "