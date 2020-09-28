module Zoom

using HTTP
using JSON

export create_meeting
export Meeting

@kwdef struct Meeting
    meeting_id::int64
    join_url::string
    password::string
    topic::string
end

function create_meeting(accessToken::String, topic::String) 
    res = HTTP.request("POST", 
    "https://api.zoom.us/v2/users/me/meetings";
    headers = [
        "Authorization" => "Bearer" * accessToken,
        "Content-Type" => "application/json"
    ];
    body=Dict("topic" => topic)
    )

    res = JSON.parse(String(res.body))

    Meeting(meeting_id = res["meeting_id"], join_url = res["join_url"],
    password = res["password"], topic = res["topic"])
end