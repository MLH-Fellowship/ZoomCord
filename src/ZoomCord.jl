module ZoomCord

using Logging, LoggingExtras

function main()
    Base.eval(Main, :(const UserApp = ZoomCord))

    include(joinpath("..", "genie.jl"))

    Base.eval(Main, :(const Genie = ZoomCord.Genie))
    Base.eval(Main, :(using Genie))
end; main()

end
