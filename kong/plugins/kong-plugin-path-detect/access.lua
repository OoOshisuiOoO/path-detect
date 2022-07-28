local http = require "resty.http"
local cjson = require "cjson.safe"

local _M = {}
function _M.execute(conf)

  local service_data = kong.router.get_service()
  local path = conf.path
  local time_out = conf.time_out
  local headers = conf.headers

  -- set config request
  local client = http.new()
  client:set_timeout(time_out)

  headers["secret"] = conf.secret
  headers["Authorization"] = kong.request.get_header("Authorization")

  local body_data = {
    path = ngx.var.upstream_uri,
    method = kong.request.get_method(),
    service = service_data.name
  }
  local body = kong.request.get_body()

  local json_string = cjson.encode(body)
  ngx.log(ngx.ERR, service_data.name,"============>Body: ",json_string)
  --ngx.log(ngx.ERR, "Errors Auth ============> ", json_string, "<============ ")
  kong.log(body_data)
  local auth_res, err = client:request_uri(path, {
    method = "POST",
    headers = headers,
    body = cjson.encode(body_data)
  })

  if not auth_res then
    return kong.response.exit(500, { message = "failed to request: " .. err })
  end

  if auth_res.status ~= 200 then
    ngx.log(ngx.INFO, "Errors Auth ============> ", auth_res.status, "<============ ")
    return kong.response.exit(auth_res.status, auth_res.body)
  end

  local json_data = cjson.decode(auth_res.body)
  if type(json_data) ~= "table" then
    return nil, "invalid json body"
  end

  if json_data['status'] ~= 200 then
    ngx.log(ngx.ERR, "Errors Auth ============> ", json_data['status'], "<============ ")
    return kong.response.exit(json_data['status'], auth_res.body)
  end
  local token = json_data['result']['token']
  kong.service.request.set_header("Authorization", "Bearer " .. token)
end

function _M.body_filter(conf)
  local body = kong.response.get_raw_body()
  ngx.log(ngx.ERR, "Result ===>", body, "<============ ")
end

return _M
