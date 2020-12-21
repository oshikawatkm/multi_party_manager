


class Script_Manager

  def initialize(number_of_party, pubkeys)
    @length_of_party = number_of_party.to_str()
    @pubkeys = pubkeys
  end

  def create_funding_script()
    asm = @length_of_party + " "
    for pubkey in @pubkeys do
      asm = asm + pubkey + " "
    end
    asm = @length_of_party + " " + "OP_CHECKMULTSIG"
    redeem = Bitcoin::Script.from_string(asm)
    hex = Bitcoin::Script.to_witness__p2sh_script(Bitcoin.sha256(redeem.to_payload.bth)).bth
    return asm, redeem, hex
  end

end