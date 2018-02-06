require "http/client"
require "json"

def getImage(userId : String) : String
  token = JSON.parse(File.read_lines("src/token.json").join)["token"]
  userInfoURL = "https://slack.com/api/users.info?token=#{token}&user=#{userId}"

  response = HTTP::Client.get userInfoURL
  userInfo = JSON.parse(response.body)

  userInfo["user"]["profile"]["image_192"].to_s
end
