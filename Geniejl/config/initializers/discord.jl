using Discord

using SearchLight
using SearchLightSQLite

using Base64

include(joinpath(pwd(), "src/zoom.jl"))
import Zoom
import Users

c = Client(ENV["DISCORD_CLIENT_TOKEN"]; presence=(game=(name="with Discord.jl", type=AT_GAME), ))

function handler(c::Client, e::MessageCreate)
    if e.message.content == "/zoom"
        discordId = e.message.author.id
        user_check = findone(Users.User; :discordId => discordId)
        if user_check === nothing
            bot_msg = fetchval(reply(c, e.message, "Please check your DM to complete authorization! :smile:"))
            
            dm_channel = fetchval(create_dm(c; recipient_id=discordId))

            state = base64encode("{\"discordId\": $discordId, \"channelId\": $(e.message.channel_id), \"messageId\": $(bot_msg.id)}")

            url = "https://zoom.us/oauth/authorize?response_type=code&client_id=3mNFRPZxSUjs8sqd7rzTg&redirect_uri=https%3A%2F%2Fzoomcord.ml%2Fauth%2F&state=$state"
            embed = Embed(title = "Authorize ZoomCord for Zoom meetings", 
            description="Streamline your entire workflow through Discord. Easily start a meeting and share the link with every using the \"/zoom\" slash command. Schedule meetings and view your upcoming meetings directly in the Discord channel. Additionally get a meeting summary and know exactly when someone joined or left the meeting.", 
            url=url,
            footer=EmbedFooter(text = "Click on the blue title to redirect to Zoom.", icon_url = "https://i.ibb.co/kKmfy1s/information-1.png"))
            
            create(c, Message, dm_channel; embed=embed)
        else
            meeting = Zoom.create_meeting(user_check, "Maaz's Personal Meeting Room")
            embed = Embed(title=meeting.topic, 
            fields=[
                EmbedField(name = "Meeting ID", value = string(meeting.id)),
                EmbedField(name = "Passowrd", value = meeting.password),
            ],
            url=meeting.join_url,
            footer=EmbedFooter(text = "Click on the blue title to redirect to Zoom meeting.", icon_url = "https://i.ibb.co/kKmfy1s/information-1.png")
            )
            reply(c, e.message, embed)
        end
    end
end

add_handler!(c, MessageCreate, handler)

open(c)