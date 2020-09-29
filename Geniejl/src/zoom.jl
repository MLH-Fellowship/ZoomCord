module Zoom

import Base: @kwdef
using HTTP
using JSON

using SearchLight
using SearchLightSQLite
using Base64
import Users

export create_meeting, Meeting

@kwdef struct Meeting
    id::Int64
    join_url::String
    password::String
    topic::String
end

function refresh(user::Users.User)
    if user.expiresIn > floor(time())
        return user
    end

    auth = base64encode("$(ENV["ZOOM_CLIENT_ID"]):$(ENV["ZOOM_CLIENT_SECRET"])")

    res = HTTP.request("POST",
    "https://zoom.us/oauth/token?grant_type=refresh_token&refresh_token=$(user.refreshToken)";
    headers = ["Authorization" => "Basic $auth"]
    )

    body = JSON.parse(String(res.body))

    user.accessToken = body["access_token"]
    user.refreshToken = body["refresh_token"]
    user.expiresIn = body["expires_in"]

    save!(user)
end

function create_meeting(user::Users.User, topic::String)
    user = refresh(user)

    res = HTTP.request("POST", 
    "https://api.zoom.us/v2/users/me/meetings";
    headers = [
        "Authorization" => "Bearer" * user.accessToken,
        "Content-Type" => "application/json"
    ],
    body=JSON.json(Dict("topic" => topic))
    )

    body = JSON.parse(String(res.body))

    Meeting(id = body["id"], join_url = body["join_url"],
    password = body["password"], topic = body["topic"])
end

end