local singletons = require "kong.singletons"
local timestamp = require "kong.tools.timestamp"
local cache = require "kong.tools.database_cache"
local policy_cluster = require "kong.plugins.oidc-user-rate-limiting.policies.cluster"
local ngx_log = ngx.log

local pairs = pairs
local fmt = string.format

local get_local_key = function(identifier, period_date, name)
  return fmt("ratelimit:%s:%s:%s", identifier, period_date, name)
end

local EXPIRATIONS = {
  second = 1,
  minute = 60,
  hour = 3600,
  day = 86400,
  month = 2592000,
  year = 31536000,
}

return {
  ["local"] = {
    increment = function(conf, identifier, current_timestamp, value)
      local periods = timestamp.get_timestamps(current_timestamp)
      for period, period_date in pairs(periods) do
        local cache_key = get_local_key(identifier, period_date, period)
        cache.sh_add(cache_key, 0, EXPIRATIONS[period])

        local _, err = cache.sh_incr(cache_key, value)
        if err then
          ngx_log("[oidc-user-rate-limiting] could not increment counter for period '"..period.."': "..tostring(err))
          return nil, err
        end
      end

      return true
    end,
    usage = function(conf, identifier, current_timestamp, name)
      local periods = timestamp.get_timestamps(current_timestamp)
      local cache_key = get_local_key(identifier, periods[name], name)
      local current_metric, err = cache.sh_get(cache_key)
      if err then
        return nil, err
      end
      return current_metric and current_metric or 0
    end
  }
}
