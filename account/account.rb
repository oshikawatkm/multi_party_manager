
require 'pry'
require 'bitcoin'
include Bitcoin::Builder
Bitcoin.network = :testnet3

class Account
  attr_accessor :name, :tx_id, :tx_index, :start_amount, :latest_amount, :address, :pubkey, :revoke_privkey, :revoke_pubkey, :prev_tx_payload, :funding_tx, :revoke_keys, :commitment_txs

  def initialize(name, tx_id, tx_index, value, address, privkey, pubkey, revoke_privkey, revoke_pubkey, prev_tx_payload)
    @name = name
    @tx_id = tx_id
    @tx_index = tx_index
    @start_amount = value.to_i
    @latest_amount = value.to_i
    @address = address
    @privkey = privkey
    @pubkey = pubkey
    @revoke_privkey = revoke_privkey
    @revoke_pubkey = revoke_pubkey
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

  def sign_funding_tx(tx)
    binding.pry
  end

  def sign_commitment_tx(tx, funding_tx)
    sign_key = Bitcoin::Key.from_base58(@privkey)
    sig_hash = tx.tx.signature_hash_for_witness_input(0, funding_tx.tx.out.last.pk_script, funding_tx.tx.out.last.value, funding_tx.redeem_script.to_payload)
    puts "ikudde"
    sig = sign_key.sign(sig_hash)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    puts "ok"
    tx.tx.in[0].script_witness.stack << sig
    return tx
  end


  def sign_revoke_tx(tx, commitment_tx)
    sign_key = Bitcoin::Key.from_base58(@revoke_privkey)

    sig_hash2 = tx.signature_hash_for_witness_input(0, commitment_tx.tx.out[2].pk_script, commitment_tx.tx.out[2].value)
    sig_hash2 = tx.signature_hash_for_witness_input(0, commitment_tx.tx.out[3].pk_script, commitment_tx.tx.out[3].value)
    sig2 = sign_key.sign(sig_hash2)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    sig3 = sign_key.sign(sig_hash3)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    tx.in[2].script_witness.stack << sig2
    tx.in[3].script_witness.stack << sig3
    return tx
  end

  def sign_revoke_sh_tx(tx, commitment_tx)
    sign_key = Bitcoin::Key.from_base58(@revoke_privkey)

    sig_hash2 = tx.signature_hash_for_witness_input(0, commitment_tx.tx.out[2].pk_script, commitment_tx.tx.out[2].value)
    sig_hash2 = tx.signature_hash_for_witness_input(0, commitment_tx.tx.out[3].pk_script, commitment_tx.tx.out[3].value)
    sig2 = sign_key.sign(sig_hash2)
    sig3 = sign_key.sign(sig_hash3)
    tx.tx.in[0].script_sig = Bitcoin::Script.to_signature_pubkey_script(sig2)
    tx.tx.in[1].script_sig
    return tx
  end

  def sign_checkout_tx(tx, commitment_tx)
    sign_key = Bitcoin::Key.from_base58(@privkey)
    sig_hash2 = tx.tx.signature_hash_for_witness_input(0, commitment_txs.last.tx.out[2].pk_script, commitment_txs.last.tx.out[2].value, commitment_txs.last.redeem_scripts[0].to_payload)
    sig_hash3 = tx.tx.signature_hash_for_witness_input(0, commitment_txs.last.tx.out[3].pk_script, commitment_txs.last.tx.out[3].value, commitment_txs.last.redeem_scripts[1].to_payload)
    sig2 = sign_key.sign(sig_hash2)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    sig3 = sign_key.sign(sig_hash3)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    tx.tx.in[0].script_witness.stack << sig2
    tx.tx.in[0].script_witness.stack << "/x1"
    tx.tx.in[0].script_witness.stack << commitment_txs.last.redeem_scripts[0].to_payload
    tx.tx.in[1].script_witness.stack << sig3
    tx.tx.in[1].script_witness.stack << "/x1"
    tx.tx.in[1].script_witness.stack << commitment_txs.last.redeem_scripts[1].to_payload
    binding.pry
    return tx
  end

  def sign_checkout_sh_tx(tx, commitment_tx)
    sign_key = Bitcoin::Key.from_base58(@privkey)
    
    sig_hash2 = tx.signature_hash_for_witness_input(0, commitment_tx.tx.out[2].pk_script, commitment_tx.tx.out[2].value)
    sig_hash2 = tx.signature_hash_for_witness_input(0, commitment_tx.tx.out[3].pk_script, commitment_tx.tx.out[3].value)
    sig2 = sign_key.sign(sig_hash2)
    sig3 = sign_key.sign(sig_hash3)
    tx.tx.in[0].script_sig = Bitcoin::Script.to_signature_pubkey_script(sig2, 0)
    tx.tx.in[1].script_sig = Bitcoin::Script.to_signature_pubkey_script(sig3, 0)
    return tx
  end

  def sign_closing_tx(tx, funding_tx)
    sign_key = Bitcoin::Key.from_base58(@privkey)
    sig_hash = tx.tx.signature_hash_for_witness_input(0, funding_tx.tx.out.last.pk_script, funding_tx.tx.out.last.value, funding_tx.redeem_script.to_payload)
    puts "ikudde"
    sig = sign_key.sign(sig_hash)+ [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
    puts "ok"
    tx.tx.in[0].script_witness.stack << sig
    return tx
  end

  def genarate_pubkey
    # priv = Bitcoin::Key.from_base58(@privkey)
  end

end 