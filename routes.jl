using Genie.Router
using DiscordAPI

route("/") do
    "Welcome to ZoomCord"
end

route("/start") do
    DiscordAPI.start()
end
