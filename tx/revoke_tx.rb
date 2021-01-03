

require './tx/tx_component/script_manager.rb'
require 'bitcoin'
Bitcoin.network = :testnet3

class Revoke_tx

  attr_accessor :account_index, :from_account_index, :to_account_index, :move_value, :funding_tx_payload, :commitment_redeem_script, :tx

  def create(account, commitment_tx, input_index)
    value = commitment_tx.out[input_index].value
    @tx = Bitcoin::Protocol::Tx.new
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("25dc4773f0bb2fe51a115adcaf0cd23c83f3e8e2073517f58b4f867e9e67fbc6", input_index))
    @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value -300, account.address))
  end

end