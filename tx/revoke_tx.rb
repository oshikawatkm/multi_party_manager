

require './tx/tx_component/script_manager.rb'
require 'bitcoin'
Bitcoin.network = :testnet3

class Revoke_tx

  attr_accessor :account_index, :from_account_index, :to_account_index, :move_value, :funding_tx_payload, :commitment_redeem_script, :tx

  def create(account, commitment_tx)
    value = commitment_tx.out[2].value + commitment_tx.out[3].value
    @tx = Bitcoin::Protocol::Tx.new
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("25dc4773f0bb2fe51a115adcaf0cd23c83f3e8e2073517f58b4f867e9e67fbc6", 2))
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("25dc4773f0bb2fe51a115adcaf0cd23c83f3e8e2073517f58b4f867e9e67fbc6", 3))
    @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value -300, account.address))
    @tx.in[0].script_witness.stack << ''
    @tx.in[1].script_witness.stack << ''
  end

end