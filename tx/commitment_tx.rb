
require 'bitcoin'
Bitcoin.network = :testnet3


class Commitment_tx

  def initialize(funding_tx_payload, funding_redeem_script)
    @prev_tx_payload = funding_tx_payload
    @prev_tx_redeem_script = funding_redeem_script
  end

  def create(accounts, funding_tx)
    account_length = accounts.length
    @tx = Bitcoin::Protocol::Tx.new
    @tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash(funding_tx.in[0].prev_out_hash.bth, 0))
    account_length.times do |i|
      @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(accounts[i].value.to_i, accounts[i].address))
    end
    (account_length - 1).times do |i|
      @tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(accounts[i].value.to_i, accounts[i].address))
    end
  end

end