using Genie.Router

using HTTP
using Base64
using JSON

using SearchLight
using SearchLightSQLite
using Users

route("/") do
  serve_static_file("welcome.html")
end

route("/auth/*") do 
  code = haskey(@params, :code) ? @params(:code) : ""
  discordId = haskey(@params, :state) ? @params(:state) : 0
  responsetype = haskey(@params, :response_type) ? @params(:response_type) == "code" : false

  if !responsetype
    return serve_static_file("auth.html")
  end

  user_check = findone(User; :discordId => discordId)
  if user_check !== nothing
    return "User already exists!"
  end

  auth = base64encode("$(ENV["ZOOM_CLIENT_ID"]):$(ENV["ZOOM_CLIENT_SECRET"])")

  res = HTTP.request("POST", "https://zoom.us/oauth/token?grant_type=authorization_code&code=$code&redirect_uri=https://zoomcord.ml/auth/"; 
  headers= ["Authorization" => "Basic $auth"])

  body = JSON.parse(String(res.body))

  accessToken = body["access_token"]
  refreshToken = body["refresh_token"]
  expiresIn = body["expires_in"]

  user = User(discordId = discordId, accessToken = accessToken, refreshToken = refreshToken, expiresIn = expiresIn)
  user |> save!

  serve_static_file("auth.html")
end