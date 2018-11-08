# kong-uma2
kong plugin for uma2 authorization

resty/uma2 is based on lua-resty-openidc 1.6.1 version  https://github.com/zmartzone/lua-resty-openidc/tree/v1.6.1 
kong/plugins/uma2/* is based on kong-oidc ac175cdc7d5b4db97859dcb7e582005911ff190d commit https://github.com/nokia/kong-oidc/commit/ac175cdc7d5b4db97859dcb7e582005911ff190d , it requires resty/uma2


# Usage
1. Install lua and luarocks
2. Install kong, and setup keycloak as uma2 configuration server
3. Copy both resty/uma2 and kong/plugins/uma2/* to /usr/local/share/lua/5.1/ directory


# TODO
1. Make lua packages 
2. Merge resty/uma2 and kong/plugins/uma2/* or make the module functionality more clear.
