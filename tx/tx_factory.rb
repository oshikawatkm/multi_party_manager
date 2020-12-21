
require './tx_component/script_manager.rb'

class Tx_Factory

  def initialize(accountArray, accountPubkeys)
    @accounts = accountArray
    @accountPubkeys = accountPubkeys
    @script_manager = Script_Manager.new(@accountPubkeys.length, @accountPubkeys)
  end

  def create_funding_tx()
    # script_manager = Script_Manager.new(@accountPubkeys.length, @accountPubkeys)
    script_asm, script_redeem, script_hex = @script_manager.create_funding_script()
    funding_tx = Funding_tx.new(@accounts, funding_script)
    return funding_tx
  end
  

  def create_closing_tx
    commitment_tx = Commitment_tx.new(@accounts, funding_tx)
    return commitment_tx
  end
    
end