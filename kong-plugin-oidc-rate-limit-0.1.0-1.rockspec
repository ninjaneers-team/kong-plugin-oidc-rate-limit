package = "kong-plugin-oidc-rate-limit"
version = "0.1.0-1"

local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "oidc-rate-limit"

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/ninjaneers-team/kong-plugin-oidc-rate-limit",
  tag = "0.1.0"
}

description = {
  summary = "A plugin for Kong which add rate limiting for oidc authenticated users",
  detailed = "To enable rate limiting add ratelimit with a numeric value (eg. 10) as a client or user claim.",
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
