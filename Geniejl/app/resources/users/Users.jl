module Users

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export User

@kwdef mutable struct User <: AbstractModel
  id::DbId = DbId()
  discordId::Int64 = 0
  accessToken::String = ""
  refreshToken::String = ""
  expiresIn::Int64 = 0
end

end
