# Kong oidc RateLimit plugin

Repository: https://github.com/ninjaneers-team/kong-plugin-oidc-rate-limit

## Rate Limit based on user/client claims

A plugin for Kong which add rate limiting for oidc authenticated users. To enable rate limiting add ratelimit with a numeric value (eg. 10) as a client or user claim.

## Installation

If you're using luarocks execute the following:
`luarocks install kong-plugin-oidc-rate-limit`

You also need to set the KONG_CUSTOM_PLUGINS environment variable
`export KONG_CUSTOM_PLUGINS=oidc-rate-limit`