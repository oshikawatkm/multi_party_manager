

require './tx/tx_component/script_manager.rb'
require 'bitcoin'
Bitcoin.network = :testnet3

class Revoke_tx

  attr_accessor :account_index, :from_account_index, :to_account_index, :move_value, :funding_tx_payload, :commitment_redeem_script, :tx

  def create(account, commitment_tx, input_index)
    value = commitment_tx.out[input_index].value
    @tx = Bitcoin::Protocol::Tx.new
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("", input_index))
    @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value -300, account.address))
  end

end