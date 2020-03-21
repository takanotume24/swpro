require "json"

SWPRO_CONF_PATH = Path["~/.swpro.json"].normalize.expand(home: true)

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

class ConfigPathSet
  JSON.mapping(
    system: {type: String, nilable: false},
    user: {type: String, nilable: false},
  )
end

class Config
  JSON.mapping(
    cmd_name: String,
    conf_path: ConfigPathSet,
    row_end: String,
    quotation: String,
    keys: {type: Keyword, nilable: false},
  )
end
