require "http/client"
require "kemal"
require "./userInfo"

res_url = token = JSON.parse(File.read_lines("src/token.json").join)["response_url"]

webhookURL = URI.parse("https://hooks.slack.com")

before_post "/surrendervote" do |env|
  env.response.content_type = "application/json"
end

post "/surrendervote" do |env|
  userId = env.params.body["user_id"].to_s
  userName = env.params.body["user_name"].to_s
  channelId = "C3NJ53VPS"
  imageURL = getImage(userId)
  text = "It's time to surrender..."
  attachments = "[
    {
      \"text\":            \"Choose your fate\",
      \"fallback\":        \"You are unable to choose an option\",
      \"callback_id\":     \"choose_fate\",
      \"color\":           \"#3AA3E3\",
      \"attachment_type\": \"default\",
      \"actions\":         [
        {
          \"name\":  \"vote\",
          \"text\":  \"Surrender\",
          \"type\":  \"button\",
          \"value\": \"surrender\",
        },
        {
          \"name\":  \"vote\",
          \"text\":  \"Keep Fighting\",
          \"type\":  \"button\",
          \"value\": \"fight\",
        },
      ],
    },
  ]"

  data = "{
  	\"text\":						\">#{text}\",
  	\"attachments\": 		\"#{attachments}\",
  	\"username\":				\"#{userName}\",
  	\"channel\":				\"#{channelId}\",
  	\"icon_url\":				\"#{imageURL}\",
  	\"response_type\":	\"in_channel\"
  }"

  # puts data

  client = HTTP::Client.new(webhookURL)
  client.tls?
  slackres = client.post res_url.to_s, form: data
  puts slackres.status_code
  puts slackres.body
  text
end

Kemal.config.port = 3001
Kemal.run
