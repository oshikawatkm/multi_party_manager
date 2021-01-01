
require 'pry'
require 'bitcoin'

Bitcoin.network = :testnet3

class Account
  attr_accessor :name, :tx_id, :tx_index, :start_amount, :latest_amount, :address, :pubkey, :prev_tx_payload, :funding_tx, :revoke_keys, :commitment_txs

  def initialize(name, tx_id, tx_index, value, address, privkey, pubkey,prev_tx_payload)
    @name = name
    @tx_id = tx_id
    @tx_index = tx_index
    @start_amount = value.to_i
    @latest_amount = value.to_i
    @address = address
    @privkey = privkey
    @pubkey = pubkey
    @prev_tx_payload = prev_tx_payload
    @revoke_keys = [] # { "revoke_privkey": 秘密鍵, "revoke_pubkey": 公開鍵 }
    @commitment_txs = []
  end

  def add_funding_tx(funding_tx)
    @funding_tx = funding_tx
  end

  def add_commitment_tx(commitment_tx)
    @commitment_txs.push(commitment_tx)
  end

  def sign(tx, funding_tx, input_index)
    sign_key = Bitcoin::Key.from_base58(@privkey)
    sig_hash = tx.tx.signature_hash_for_witness_input(0, tx.tx.out[0].script, 100000, tx.redeem_script.to_payload)
    sig = sign_key.sign(sig_hash)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    tx.tx.in[input_index].script_witness.stack << sig
    return tx
  end

  def genarate_pubkey
    priv = Bitcoin::Key.from_base58(@privkey)
  end

end 