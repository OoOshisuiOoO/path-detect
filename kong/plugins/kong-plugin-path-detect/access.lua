local http = require "resty.http"
local cjson = require "cjson.safe"

local _M = {}

local function init_worker()

  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")

end --]]

-- runs in the 'access_by_lua_block'
local function access(plugin_conf)
  local route = kong.router.get_route()
  local protocols = route.id
  ngx.log(ngx.ERR, "============ Hello World! ============ 1")
  --return kong.response.exit(500, { message = "Not FOUND nha" })
  kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!
  --kong.service.request.set_header(plugin_conf.request_header, "this is on a request")
  ngx.log(ngx.ERR, "============ Hello World! ============ 2")
  return kong.response.exit(500, { message = "An unexpected error happened" })
end --]]

function _M.execute(conf)
  ngx.log(ngx.ERR, "============ Hello World! ============ 2")
  local route = kong.router.get_route()
  --local new_data = kong.db.routes:select({ id = route.id })
  ngx.log(ngx.ERR, "============ Hello World! ============ :", route.mapping_id)
end

return _M
