require 'pry'
require 'bitcoin'
Bitcoin.network = :testnet3

class Script_Manager

  def initialize(number_of_party, pubkeys)
    @length_of_party = number_of_party.to_s()
    @pubkeys = pubkeys
  end

  def create_funding_script()
    asm = @length_of_party + " "
    for pubkey in @pubkeys do
      asm += pubkey + " "
    end
    asm += @length_of_party + " " + "OP_CHECKMULTISIG"
    redeem = Bitcoin::Script.from_string(asm)
    hex = Bitcoin::Script.to_witness_p2sh_script(Bitcoin.sha256(redeem.to_payload.bth)).bth
    return asm, redeem, hex
  end

  def create_commitment_script(revoke_pubkey, revoke_account_pubkey, checkout_account_pubkey ,nlocktime)
    locktime = 6
    # asm = "OP_IF 2 #{revoke_pubkey} #{revoke_account_pubkey} 2 OP_CHECKMULTISIG OP_ELSE #{locktime} OP_NOP3 OP_DROP #{checkout_account_pubkey} OP_CHECKSIG OP_ENDIF"
    asm = "OP_IF 2 #{revoke_pubkey} #{revoke_account_pubkey} 2 OP_CHECKMULTISIG OP_ELSE #{revoke_pubkey} OP_CHECKSIG OP_ENDIF"
    redeem = Bitcoin::Script.from_string(asm)
    hex = Bitcoin::Script.to_witness_p2sh_script(Bitcoin.sha256(redeem.to_payload.bth)).bth
    return asm, redeem, hex
  end

  def create_revoke_script(pubkey)
    pubkey_hash = Bitcoin.hash160(pubkey)
    asm = "0 " + pubkey_hash
    hex = Bitcoin::Script.to_witness_hash160_script(pubkey_hash).bth
    return asm
  end
end