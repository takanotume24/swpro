require "json"
PATH_CONF_APT   = "./apt.conf"
HTTP_PROXY_APT  = "Acquire::http::Proxy"
HTTPS_PROXY_APT = "Acquire::https::Proxy"
PATH_CONF_WGET  = "./.wgetrc"
HTTP_PROXY_WGET = "http_proxy="

class Keyword
  JSON.mapping(
    http_proxy: {type: OptionSet, nilable: false},
    https_proxy: {type: OptionSet, nilable: false},
  )
end

class RegexSet
  JSON.mapping(
    regex: String,
    string: String,
  )
end

class OptionSet
  JSON.mapping(
    enable_set: {type: RegexSet, nilable: false},
    disable_set: {type: RegexSet, nilable: false},
  )
end

class Config
  JSON.mapping(
    cmd_name: String,
    conf_path: String,
    keys: {type: Keyword, nilable: false},
  )
end
