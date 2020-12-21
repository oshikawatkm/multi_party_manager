

 require "json"


class  JSON_Reader 

  def read_json(path)
    File.open(path) do | file |
      json = JSON.load(file)
      return json
    end
  end
end