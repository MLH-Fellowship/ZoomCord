using Discord

include("./ZoomAPI.jl")

function main()
    client = Client(ENV["DISCORD_CLIENT_ID"])
    add_command!(client, :create_meeting; pattern=r"^/zoomcord create$") do c, msg
        response = create_meeting("-dmxbmG_TaabjaLuE9hCfw")
        reply(client, msg, String(response))
    end
    open(client)
    return client
end

if abspath(PROGRAM_FILE) == @__FILE__
    client = main()
    wait(client)
end
