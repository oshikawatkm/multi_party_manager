
require 'pry'
require 'bitcoin'
Bitcoin.network = :testnet3

class Account
  attr_accessor :name, :tx_id, :tx_index, :value, :address, :pubkey, :prev_tx_payload, :funding_tx, :commitment_txs

  def initialize(name, tx_id, tx_index, value, address, privkey, pubkey,prev_tx_payload)
    @name = name
    @tx_id = tx_id
    @tx_index = tx_index
    @value = value
    @address = address
    @privkey = privkey
    @pubkey = pubkey
    @prev_tx_payload = prev_tx_payload
    @commitment_txs = []
  end

  def add_funding_tx(funding_tx)
    @funding_tx = funding_tx
  end

  def add_commitment_tx(commitment_tx)
    @commitment_txs.push(commitment_tx)
  end

  def sign(index)
    tx = @commitment_txs[index]
    sig_hash = tx.signature_hash_for_witness_input(0, tx.out[0], tx.script, 100000, tx.redeem_script.to_payload)
    sig = @pubkey.sign(sig_hash)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    @commitment_txs[index].in[index].stack << sig
    @commitment_txs[index].in[index].stack << preimage.htb
    @commitment_txs[index].in[index].stack << redeem_script.to_payload
  end

  def genarate_pubkey
    priv = Bitcoin::Key.from_base58(@privkey)
  end

end 