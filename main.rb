
require './account/account_factory'
require './protocol/protocol'
require './lib/json_reader'


# 定数
CONFIG_JSON_PATH = "./config.json"


def main
  accounts = []
  accountPubeys = []
  # #  コマンドライン引数のアカウント個数を取得
  # account_factory_count = ARGV[0].to_i

  # config.jsonの読み込み
  json_reader = JSON_Reader.new()
  json_data = json_reader.read_json(CONFIG_JSON_PATH)
  accounts_data = json_data["accounts"]

  # アカウントの作成
  account_factory = Account_Factory.new()
  for account_data in accounts_data do
    account = account_factory.create(account_data)
    # account.genarate_pubkey()
    accountPubeys.push(account.pubkey)
    accounts.push(account)
  end

  nlocktime = json_data["nlocktime"].to_i
  protocol = Protocol.new(accountPubeys, nlocktime)
  protocol.opening_processes(accounts, accountPubeys)

  protocol.update_processes(accounts, 0, 1, 1000)
  protocol.update_processes(accounts, 0, 1, 1000)
  binding.pry
end


if __FILE__ == $0
  main
end