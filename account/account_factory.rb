
require './account/account'

class Account_Factory

  attr_accessor :account_count

  def create(account_data)
      # tx_id, tx_index, value, address, pubkey = gets_account_data()
      account = Account.new(account_data["name"], account_data["tx_id"], account_data["tx_index"], account_data["value"], account_data["address"], account_data["pubkey"], account_data["prev_tx_payload"])
      return account
  end
  
  # def gets_account_data
  #   puts "[*] 変数の設定を行います"
  #   puts "[+] トランザクションID: "
  #   tx_id = STDIN.gets 
  #   puts "[+] トランザクションのインデックス "
  #   tx_index = STDIN.gets
  #   puts "[+] 送付するビットコインの量(satochi)"
  #   value = STDIN.gets
  #   puts "[+] アドレス"
  #   address = STDIN.gets
  #   puts "[+] 公開鍵"
  #   pubkey = STDIN.gets
  #   return tx_id, tx_index, value, address, pubkey
  # end

end