module DiscordAPI

using Discord

include("./ZoomAPI.jl")

const PREFIX = "/zoomcord "

function create_cmd(client::Client, msg::Message)
    response = create_meeting("-dmxbmG_TaabjaLuE9hCfw")
    reply(client, msg, String(response))
end

function client(token::String, prefix::String)
    client = Client(token; prefix=prefix, presence=(game = (name = prefix, type = AT_LISTENING),),)
    add_command!(
        client, :create_meeting, create_cmd;
        pattern=r"^create$",
        help="Create a new meeting"
    )
    return client
end

function start()
    c = client(ENV["DISCORD_TOKEN"], PREFIX)
    while true
        open(c)
        wait(c)
        isopen(c) && close(c)
    end
end

end
