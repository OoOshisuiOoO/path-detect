local access = require "kong.plugins.kong-plugin-path-detect.access"

local PathDetectHandler = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}

function PathDetectHandler:access(conf)
  access.execute(conf)
end
function PathDetectHandler:body_filter(conf)
  access.body_filter(conf)
end
return PathDetectHandler

