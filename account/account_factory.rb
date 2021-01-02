
require './account/account'
require "pry"

class Account_Factory

  def create(account_data)
      account = Account.new(
        account_data["name"], 
        account_data["tx_id"], 
        account_data["tx_index"], 
        account_data["value"],
        account_data["address"],
        account_data["privkey"],
        account_data["pubkey"], 
        account_data["prev_tx_payload"])
      return account
  end

end