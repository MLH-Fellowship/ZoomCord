using Discord
# using ENV
# Create a client.
c = Client(ENV["DISCORD_TOKEN"]; presence=(game=(name="with Discord.jl", type=AT_GAME),))
# Create a handler for the MessageCreate event.
function handler(c::Client, e::MessageCreate)
    # Display the message contents.
    if e.message.content == "Hey"
        println("Received message: $(e.message.content)")
        # Add a reaction to the message.
        create(c, Reaction, e.message, '👍')
        reply(c, e.message, "Hello World!")
    end  
end

# Add the handler.
add_handler!(c, MessageCreate, handler)
# Log in to the Discord gateway.
open(c)
# Wait for the client to disconnect.
wait(c)