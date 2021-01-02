
require 'pry'
require 'bitcoin'
include Bitcoin::Builder
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

  def sign_commitment_tx(tx, funding_tx)
    puts "HELLO"
    sign_key = Bitcoin::Key.from_base58(@privkey)
    sig_hash = tx.tx.signature_hash_for_witness_input(0, funding_tx.tx.out.last.pk_script, funding_tx.tx.out.last.value, funding_tx.redeem_script.to_payload)
    puts "ikudde"
    sig = sign_key.sign(sig_hash)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    puts "ok"
    tx.tx.in[0].script_witness.stack << sig
    return tx
  end

  def sign_funding_tx(tx)
    binding.pry
  end

  def genarate_pubkey
    priv = Bitcoin::Key.from_base58(@privkey)
  end

end 