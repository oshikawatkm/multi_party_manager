
require 'bech32'
require 'digest'

class Multisig_Address

  def initialize(pubkey)
    @pubkey = pubkey
  end

  def create(script_pubkey)
    hash160 = Digest::RMD160.hexdigest Digest::SHA256.digest([@pubkey].pack("H*"))
    ad = Bech32::SegwitAddr.new
    ad.hrp = 'tb'
    segwit_addr = Bech32::SegwitAddr.new(addr.addr)
    segwit_addr.to_script_pubkey = script_pubkey
    segwit_addr.hrp = 'tb'
    puts segwit_addr.addr
    return segwit_addr
  end

end