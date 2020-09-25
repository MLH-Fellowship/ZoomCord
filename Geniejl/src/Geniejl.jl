module Geniejl

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = Geniejl))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = Geniejl.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
