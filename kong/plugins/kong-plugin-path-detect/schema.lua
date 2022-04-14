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

        -- p  ath authentication
        { path = {
          type = "string",
          required = true,
        } },
        -- headers authentication
        { headers = typedefs.headers {
          keys = typedefs.header_name {
            required = false,
            match_none = {
              {
                pattern = "^[Hh][Oo][Ss][Tt]$",
                err = "cannot contain 'host' header, which must be specified in the 'hosts' attribute",
              },
            },
          },
        } },


        -- secret sv2
        { secret = {
          required = true,
          type = "string"
        }, },

        -- time_out authentication
        { time_out = {
          required = false,
          type = "integer",
          default = 5
        }, },

      },
    },
    },
  },
}

return schema
