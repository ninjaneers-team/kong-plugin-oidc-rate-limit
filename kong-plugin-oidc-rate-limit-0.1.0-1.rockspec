package = "kong-plugin-oidc-rate-limit"
version = "0.1.0-1"

local pluginName = "oidc-rate-limit"

supported_platforms = {"linux", "macosx"}
source = {
  url = "git+https://github.com/ninjaneers-team/kong-plugin-oidc-rate-limit",
  tag = "0.1.0"
}

description = {
  summary = "A plugin for Kong which add rate limiting for oidc authenticated users",
  detailed = "To enable rate limiting add ratelimit with a numeric value (eg. 10) as a client or user claim. You also need to set the KONG_CUSTOM_PLUGINS environment variable _export KONG_CUSTOM_PLUGINS=oidc-rate-limit_",
  homepage = "https://github.com/ninjaneers-team/kong-plugin-oidc-rate-limit",
  license = "Apache 2.0"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
    ["kong.plugins."..pluginName..".daos"] = "kong/plugins/"..pluginName.."/daos.lua",
    ["kong.plugins."..pluginName..".policies.cluster"] = "kong/plugins/"..pluginName.."/policies/cluster.lua",
    ["kong.plugins."..pluginName..".policies.init"] = "kong/plugins/"..pluginName.."/policies/init.lua",
    ["kong.plugins."..pluginName..".migrations.postgres"] = "kong/plugins/"..pluginName.."/migrations/postgres.lua",
  }
}
