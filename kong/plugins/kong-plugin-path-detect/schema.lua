local typedefs = require "kong.db.schema.typedefs"

local plugin_name = ({ ... })[1]:match("^kong%.plugins%.([^%.]+)")

local schema = {
  name = plugin_name,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer }, -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
      -- The 'config' record is the custom part of the plugin schema
      type = "record",
      fields = {
        -- a standard defined field (typedef), with some customizations
        { authentication_domain = {
          type = "string",
          required = true,
        } },
        { authentication_port = {
          type = "integer",
          required = true,
          gt = 0,
        } }, -- adding a constraint for the value
      },
    },
    },
  },
}

return schema
