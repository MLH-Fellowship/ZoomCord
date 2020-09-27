using HTTP
using JSON

const headers = [
    "Authorization" => "Bearer " * ENV["ZOOM_JWT_TOKEN"],
    "Content-Type" => "application/json"
]

function create_meeting(userId)
    result = HTTP.request(
        "POST",
        "https://api.zoom.us/v2/users/$userId/meetings",
        headers,
        "{\"topic\": \"test meeting\"}"
    )
    return JSON.parse(String(result.body))["join_url"]
end
