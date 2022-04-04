local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-plugin-path-detect",
  fields = {
    { consumer = typedefs.no_consumer },
    { config = {
      type = "record",
      fields = {
        { mapping_id = { type = "string" }, }
      }, }, },
  },
}
