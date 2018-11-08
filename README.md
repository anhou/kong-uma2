# kong-uma2
kong plugin for uma2 authorization

* resty/uma2 is based on lua-resty-openidc 1.6.1 version  https://github.com/zmartzone/lua-resty-openidc/tree/v1.6.1 
* kong/plugins/uma2/* is based on kong-oidc 5c34b84e9e5463841ae36392026c6511c6524933 commit https://github.com/nokia/kong-oidc/commit/5c34b84e9e5463841ae36392026c6511c6524933 , it requires resty/uma2


# Usage
1. Install lua and luarocks
2. Install kong, and setup keycloak as uma2 configuration server
3. Copy both resty/uma2 and kong/plugins/uma2/* to /usr/local/share/lua/5.1/ directory
4. Change kong configuration in /etc/kong/kong.conf

```
log_level = debug
...
plugins = bundled,uma2
...
proxy_listen = 0.0.0.0:9527
...
pg_host = 127.0.0.1             # The PostgreSQL host to connect to.
pg_port = 5432                  # The port to connect to.
pg_user = kong                  # The username to authenticate if required.
pg_password = kong                  # The password to authenticate if required.
pg_database = kong              # The database name to connect to.
```

* Enable plugin `uma2` for service `abc`, the configuration is as below.

```
$ curl localhost:8001/services/abc | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   240  100   240    0     0  33693      0 --:--:-- --:--:-- --:--:-- 34285
{
  "host": "xx.xx.xx.xy",
  "created_at": 1538416004,
  "connect_timeout": 60000,
  "id": "aae791c9-f6f2-4f35-9752-8d680c5cb778",
  "protocol": "http",
  "name": "pacs",
  "read_timeout": 60000,
  "port": 9527,
  "updated_at": 1541054013,
  "retries": 5,
  "write_timeout": 60000
}

$ curl localhost:8001/services/abc/plugins | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   698  100   698    0     0  21886      0 --:--:-- --:--:-- --:--:-- 22516
{
  "total": 1,
  "data": [
    {
      "created_at": 1540308975000,
      "config": {
        "response_type": "code",
        "realm": "kong",
        "redirect_after_logout_uri": "/",
        "uma2_discovery": "http://xx.xx.xx.xx:8180/auth/realms/spring-boot-quickstart/.well-known/uma2-configuration",
        "token_endpoint_auth_method": "client_secret_post",
        "client_secret": "3fcf098b-f6e3-4449-a085-d56649b922cf",
        "client_id": "kong-uma2",
        "bearer_only": "no",
        "scope": "openid",
        "ssl_verify": "no",
        "discovery": "http://xx.xx.xx.xx:8180/auth/realms/spring-boot-quickstart/.well-known/openid-configuration",
        "logout_path": "/logout"
      },
      "id": "33c015bd-3936-4015-bf50-16705a231fed",
      "name": "uma2",
      "service_id": "aae791c9-f6f2-4f35-9752-8d680c5cb778",
      "enabled": true
    }
  ]
}

```
# TODO
1. Make lua packages 
2. Merge resty/uma2 and kong/plugins/uma2/* or make the module functionality more clear.
