local BasePlugin = require "kong.plugins.base_plugin"
local uma2Handler = BasePlugin:extend()
local utils = require("kong.plugins.uma2.utils")
local filter = require("kong.plugins.uma2.filter")
local session = require("kong.plugins.uma2.session")

uma2Handler.PRIORITY = 1000


function uma2Handler:new()
  uma2Handler.super.new(self, "uma2")
end

function uma2Handler:access(config)
  ngx.log(ngx.DEBUG, "uma2Handler start")
  uma2Handler.super.access(self)
  local oidcConfig = utils.get_options(config, ngx)

--  if filter.shouldProcessRequest(oidcConfig) then
--    session.configure(config)
  uma2_handle(oidcConfig)
--  else
--    ngx.log(ngx.DEBUG, "uma2Handler ignoring request, path: " .. ngx.var.request_uri)
--  end

  ngx.log(ngx.DEBUG, "uma2Handler done")
end

function uma2_handle(oidcConfig)
  ngx.log(ngx.DEBUG, "uma2_handle")
  local response
--  if oidcConfig.introspection_endpoint then
--    response = introspect(oidcConfig)
--    if response then
--      utils.injectUser(response)
--    end
--  end
--
--  if response == nil then
    response = make_uma2(oidcConfig)
      ngx.log(ngx.DEBUG, "andrew========= after make_uma2 ")
    if response and response.user then
      ngx.log(ngx.DEBUG, "andrew=========1 after make_uma2 ")
      utils.injectUser(response.user)
    end
--  end
end

function make_uma2(oidcConfig)

  ngx.log(ngx.DEBUG, "uma2Handler calling authenticate, requested path: " .. ngx.var.request_uri)
  local res, err = require("resty.uma2").authenticate(oidcConfig)
  if err then
    if oidcConfig.recovery_page_path then
      ngx.log(ngx.DEBUG, "Entering recovery page: " .. oidcConfig.recovery_page_path)
      ngx.redirect(oidcConfig.recovery_page_path)
    end
    utils.exit(500, err, ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
  return res
end

function introspect(oidcConfig)
  if utils.has_bearer_access_token() or oidcConfig.bearer_only == "yes" then
    local res, err = require("resty.uma2").introspect(oidcConfig)
    if err then
      if oidcConfig.bearer_only == "yes" then
        ngx.header["WWW-Authenticate"] = 'Bearer realm="' .. oidcConfig.realm .. '",error="' .. err .. '"'
        utils.exit(ngx.HTTP_UNAUTHORIZED, err, ngx.HTTP_UNAUTHORIZED)
      end
      return nil
    end
    ngx.log(ngx.DEBUG, "uma2Handler introspect succeeded, requested path: " .. ngx.var.request_uri)
    return res
  end
  return nil
end


return uma2Handler
