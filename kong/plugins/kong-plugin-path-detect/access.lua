local http = require "resty.http"
local cjson = require "cjson.safe"

local _M = {}
function _M.execute(conf)
  ngx.log(ngx.ERR, "============>Path detect start <============ ")
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
  ngx.log(ngx.ERR, "Path =====> ", path)
  ngx.log(ngx.ERR, "Method =====> ", method)
  ngx.log(ngx.ERR, "Service =====> ", service)
  ngx.log(ngx.ERR, "Host =====> ", service_data.host)

  local auth_res, err = client:request_uri(path, {
    method = "POST",
    headers = headers,
    body = cjson.encode(body_data)
  })

  if not auth_res then
    ngx.log(ngx.ERR, "failed to request: ", err)
    return kong.response.exit(500, { message = "failed to request: " .. err })
  end

  if auth_res.status ~= 200 then
    ngx.log(ngx.ERR, "Errors Auth ============> ", auth_res.status, "<============ ")
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
  ngx.log(ngx.ERR, "============>Path detect end <============ ")
end

return _M
