using Genie.Router

using HTTP
using Base64

using SearchLight
using SearchLightSQLite
using Users

route("/") do
  serve_static_file("welcome.html")
end

route("/auth/*") do 
  code = haskey(@params, :code) ? @params(:code) : ""
  discordId = haskey(@params, :state) ? @params(:state) : 0

  user_check = findone(User; :discordId => discordId)
  if user_check === nothing
    return "User already exists!"
  end

  auth = base64encode("$(ENV["ZOOM_CLIENT_ID"]):$(ENV["ZOOM_CLIENT_SECRET"])")

  req = HTTP.request("POST", "https://zoom.us/oauth/token?grant_type=authorization_code&code=$code&redirect_uri=https://zoomcord.ml", ("Authorization" => "Basic $auth"))

  accessToken = r.body["access_token"]
  refreshToken = r.body["refresh_token"]
  expiresIn = r.body["expires_in"]

  user = User(discordId = discordId, accessToken = accessToken, refreshToken = refreshToken, expiresIn = expiresIn)
  user |> save!

  serve_static_file("auth.html")
end