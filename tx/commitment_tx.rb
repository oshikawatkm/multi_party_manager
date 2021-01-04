
require './tx/tx_component/script_manager.rb'
require 'bitcoin'
Bitcoin.network = :testnet3


class Commitment_tx

  attr_accessor :account_index, :from_account_index, :to_account_index, :move_value, :funding_tx_payload, :funding_redeem_script, :tx, :redeem_scripts

  def initialize(account_index, funding_tx_payload, from_account_index, to_account_index, move_value, funding_redeem_script)
    @account_index = account_index
    @from_account_index = from_account_index
    @to_account_index = to_account_index
    @move_value = move_value
    @prev_tx_payload = funding_tx_payload
    @prev_tx_redeem_script = funding_redeem_script
    @redeem_scripts = []
  end
  
  def create(script_manager, nlocktime, accounts, funding_tx)
    account_length = accounts.length
    @tx = Bitcoin::Protocol::Tx.new
    # prev_tx = Bitcoin::Protocol::Tx.new(funding_tx.to_payload.bth)
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("b1a3f844a27c31f1d1c511a96d02915c550459b31ef56c127b7dbf40bb1120ab", 2))
    account_length.times do |i|
      if i != @account_index
        value = accounts[i].latest_amount
        if i == @from_account_index
          value -= @move_value
        elsif i == @to_account_index
          value += @move_value
        end
        @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value - 100, accounts[i].address))
      end
    end
    account_length.times do |i|
      if i != @account_index
        lock_value = accounts[@account_index].latest_amount
        if @account_index == @from_account_index
          lock_value -= @move_value
        elsif @account_index == @to_account_index
          lock_value += @move_value
        end
        splited_lock_value = lock_value / (account_length - 1)
        script_asm, script_redeem, script_hex = script_manager.create_commitment_script(accounts[@account_index].revoke_pubkey, accounts[i].pubkey, accounts[@account_index].pubkey, nlocktime)
        script_pubkey = Bitcoin::Script.from_string("0 #{Bitcoin.sha256(script_redeem.to_payload.bth)}")
        # script_pubkey = Bitcoin::Script.from_string("#{script_redeem.to_payload.bth}")
        @tx.add_out(Bitcoin::Protocol::TxOut.new(splited_lock_value - 100, script_pubkey.to_payload))
        @redeem_scripts.push(script_redeem)
      end
    end
    @tx.in[0].script_witness.stack << ""
  end

end