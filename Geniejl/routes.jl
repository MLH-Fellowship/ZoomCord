using Genie.Router

using HTTP
using Base64
using JSON

using SearchLight
using SearchLightSQLite
import Users

using Discord

route("/") do
  serve_static_file("welcome.html")
end

route("/auth/*") do 
  code = haskey(@params, :code) ? @params(:code) : ""
  state = haskey(@params, :state) ? @params(:state) : ""
  state = JSON.parse(String(base64decode(state)))

  discordId = haskey(state, "discordId") ? state["discordId"] : 0
  channelId = haskey(state, "channelId") ? state["channelId"] : 0
  messageId = haskey(state, "messageId") ? state["messageId"] : 0

  user_check = findone(Users.User; :discordId => discordId)
  if user_check !== nothing
    return "User already exists!"
  end

  auth = base64encode("$(ENV["ZOOM_CLIENT_ID"]):$(ENV["ZOOM_CLIENT_SECRET"])")

  res = HTTP.request("POST", "https://zoom.us/oauth/token?grant_type=authorization_code&code=$code&redirect_uri=https://zoomcord.ml/auth/"; 
  headers = ["Authorization" => "Basic $auth"])

  body = JSON.parse(String(res.body))

  accessToken = body["access_token"]
  refreshToken = body["refresh_token"]
  expiresIn = time() + 3500

  user = Users.User(discordId = discordId, accessToken = accessToken, refreshToken = refreshToken, expiresIn = expiresIn)
  user |> save!


  c = Client(ENV["DISCORD_CLIENT_TOKEN"]; presence=(game=(name="with Discord.jl", type=AT_GAME), ))
  open(c)

  edit_message(c, channelId, messageId; content="Authorization successful!")

  close(c)
  
  serve_static_file("auth.html")
end