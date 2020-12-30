
require 'pry'
require 'bitcoin'
Bitcoin.network = :testnet3


class Funding_tx

  attr_accessor :script_asm, :script_hex, :redeem_script, :tx

  def initialize(script_asm, script_redeem, script_hex)
    @script_asm = script_asm
    @script_hex = script_hex
    @redeem_script = script_redeem
  end

  def create(accounts)
    @tx = Bitcoin::Protocol::Tx.new
    script_pubkey = Bitcoin::Script.from_string("0 #{Bitcoin.sha256(@redeem_script.to_payload.bth)}")
    total_funding_value = 0
    for account in accounts do
      funding_value = account.value.to_i
      total_funding_value += funding_value
      prev_tx = Bitcoin::Protocol::Tx.new(account.prev_tx_payload.htb)
      prev_tx_value = prev_tx.out[account.tx_index].value
      @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash(account.tx_id, account.tx_index))
      if prev_tx_value - funding_value != 0
        @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(prev_tx_value - funding_value, account.address))
      end
    end
    @tx.add_out(Bitcoin::Protocol::TxOut.new(total_funding_value, script_pubkey.to_payload))
  end
end