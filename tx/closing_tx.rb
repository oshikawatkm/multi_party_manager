require 'bitcoin'
Bitcoin.network = :testnet3

class Closing_tx

  attr_accessor :account_index, :from_account_index, :to_account_index, :move_value, :funding_tx_payload, :funding_redeem_script, :tx, :redeem_scripts

  def create(accounts)
    account_length = accounts.length
    @tx = Bitcoin::Protocol::Tx.new
    # prev_tx = Bitcoin::Protocol::Tx.new(funding_tx.to_payload.bth)
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash("b1a3f844a27c31f1d1c511a96d02915c550459b31ef56c127b7dbf40bb1120ab", 2))
    account_length.times do |i|
      value = accounts[i].latest_amount
      if i == @from_account_index
        value -= @move_value
      elsif i == @to_account_index
        value += @move_value
      end
      @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value - 100, accounts[i].address))
    end
    @tx.in[0].script_witness.stack << ""
  end

end