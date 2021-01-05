

require './tx/tx_component/script_manager.rb'
require 'bitcoin'
Bitcoin.network = :testnet3

class Checkout_tx

  attr_accessor :account_index, :from_account_index, :to_account_index, :move_value, :funding_tx_payload, :commitment_redeem_script, :tx, :redeem_script

  def create(account, commitment_tx)
    value = commitment_tx.tx.out[2].value #+ commitment_tx.tx.out[3].value
    @tx = Bitcoin::Protocol::Tx.new
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("94adb650eda3777c6f2da599294cf54b14f7fdd596040b8256185ce8371b0c32", 2))
    # @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("94adb650eda3777c6f2da599294cf54b14f7fdd596040b8256185ce8371b0c32", 3))
    @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value -300, account.address))
    # @tx.in[0].script_witness.stack << ''
    # @tx.in[1].script_witness.stack << ''
  end

end