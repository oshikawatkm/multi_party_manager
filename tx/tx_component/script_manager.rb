require 'pry'


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

  def create_commitment_script(revoke_pubkey, pubkey, nlocktime)
    locktime = nlocktime + 10
    asm = "OP_IF #{revoke_pubkey} OP_ELSE #{locktime} OP_NOP3 OP_DROP #{pubkey} OP_ENDIF OP_CHECKSIG"
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