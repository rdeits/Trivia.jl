# This file contains some helpful methods for making requests to the opentdb.com servers

"""
Check that the response code from the OpenTDB API indicates success
"""
function check_response(json)
    json["response_code"] == 0 || error("API returned non-zero response code: $(json["response_code"])")
    json
end

"""
Check that the HTTP response from the server is OK
"""
function check_http_response(r)
    r.status == 200 || error("Got HTTP status $(r.status)")
    r
end

"""
Make a request to the opentdb.com API and verify that both the HTTP response is OK and that the API
returned a successful response code.

Returns the resulting JSON data as a dictionary.
"""
function opentdb_request(url)
    r = check_http_response(
        HTTP.request("GET", url))
    json = check_response(JSON.parse(String(r.body)))
    json
end
