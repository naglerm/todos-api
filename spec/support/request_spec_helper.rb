module RequestSpecHelper
  #parse JSON objects to ruby hash
  def json
    JSON.parse(response.body)
  end
end
