local package_name = "kong-plugin-path-detect"
local package_version = "0.1.1"
local rockspec_revision = "1"

local github_account_name = "sh1su1"
local github_repo_name = "path-detect"
local git_checkout = package_version == "dev" and "master" or package_version


package = package_name
version = package_version .. "-" .. rockspec_revision
supported_platforms = { "linux", "macosx" }
source = {
  url = "git+http://github.com/"..github_account_name.."/"..github_repo_name..".git",
  branch = git_checkout,
}


description = {
  summary = "Kong is a scalable and customizable API Management Layer built on top of Nginx.",
  homepage = "https://"..github_account_name..".github.io/"..github_repo_name,
  license = "0ooShuSuioo0",
}


dependencies = {
}


build = {
  type = "builtin",
  modules = {
    -- TODO: add any additional code files added to the plugin
    ["kong.plugins."..package_name..".access"] = "kong/plugins/"..package_name.."/access.lua",
    ["kong.plugins."..package_name..".handler"] = "kong/plugins/"..package_name.."/handler.lua",
    ["kong.plugins."..package_name..".schema"] = "kong/plugins/"..package_name.."/schema.lua",
  }
}
