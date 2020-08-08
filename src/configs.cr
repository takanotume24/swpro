require "json"

SWPRO_CONF_PATH = Path["~/.swpro.json"].normalize.expand(home: true)

# class Keyword
# JSON.mapping(
#   http_proxy: {type: OptionSet, nilable: false},
#   https_proxy: {type: OptionSet, nilable: false},
# )
# end

def Regex.new(pull : JSON::PullParser)
  new pull.read_string
end

class Keyword
  include JSON::Serializable
  property http_proxy : OptionSet
  property https_proxy : OptionSet
end

class RegexSet
  include JSON::Serializable
  property regex : Regex
  property string : String
end

class OptionSet
  include JSON::Serializable
  property enable_set : RegexSet
  property disable_set : RegexSet
end

class ConfigPathSet
  include JSON::Serializable
  property system : Path?
  property user : Path?
end

class Config
  include JSON::Serializable
  property cmd_name : String
  property conf_path : ConfigPathSet?
  property keys : Keyword?
  property require_setting : String?
  property after_execute : Array(String)?
end
