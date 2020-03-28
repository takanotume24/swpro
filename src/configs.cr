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
    system: {type: String, nilable: true},
    user: {type: String, nilable: true},
  )
end

class Config
  JSON.mapping(
    cmd_name: String,
    conf_path: {type: ConfigPathSet, nilable: true},
    row_end: {type: String, nilable: true},
    quotation: {type: String, nilable: true},
    keys: {type: Keyword, nilable: true},
    require_setting: {type: String, nilable: true},
    after_execute: {type: String, nilable: true}
  )
end
