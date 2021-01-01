
require './tx/tx_component/script_manager.rb'
require 'bitcoin'
Bitcoin.network = :testnet3


class Refund_tx

  attr_accessor :script_asm, :redeem_script, :script_hex, :tx

  def initialize(account_index, funding_tx_payload, funding_redeem_script)
    @account_index = account_index
    @prev_tx_payload = funding_tx_payload
    @prev_tx_redeem_script = funding_redeem_script
  end

  def create(script_manager, nlocktime, accounts, funding_tx)
    account_length = accounts.length
    @tx = Bitcoin::Protocol::Tx.new
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash(funding_tx.tx.in[0].prev_out_hash.bth, 0))
    account_length.times do |i|
      if i != @account_index
        @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(accounts[i].start_amount, accounts[i].address))
      end
    end
    account_length.times do |i|
      if i != @account_index
        splited_value = accounts[i].start_amount / (account_length - 1)
        @script_asm, @redeem_script, @script_hex = script_manager.create_commitment_script(accounts[i].revoke_keys[0]["revoke_pubkey"], accounts[i].pubkey, nlocktime)
        script_pubkey = Bitcoin::Script.from_string("0 #{Bitcoin.sha256(@redeem_script.to_payload.bth)}")
        @tx.add_out(Bitcoin::Protocol::TxOut.new(splited_value, script_pubkey.to_payload))
        @tx.in[0].script_witness.stack << funding_tx.redeem_script.to_payload
      end
    end
  end

end