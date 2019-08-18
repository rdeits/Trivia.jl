function check_response(json)
    json["response_code"] == 0 || error("API returned non-zero response code: $(json["response_code"])")
    json
end

function check_http_response(r)
    r.status == 200 || error("Got HTTP status $(r.status)")
    r
end

function opentdb_request(url)
    r = check_http_response(
        HTTP.request("GET", url))
    json = check_response(JSON.parse(String(r.body)))
    json
end
