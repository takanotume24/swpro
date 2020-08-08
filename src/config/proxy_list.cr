require "json"
require "./user_config"

module Switch::Proxy::Config::ProxyConfig
  SWPRO_PROXY_LIST_PATH = Path["~/.swpro/proxy_list.json"].normalize.expand(home: true)

  def Regex.new(pull : JSON::PullParser)
    user_config = Switch::Proxy::Config::UserConfig::UserConfig.from_json(File.read Path["~/.swpro/user_config.json"].normalize.expand(home: true))
    string = pull.read_string.gsub "REPLACEMENT", user_config.domain
    new string, Regex::Options::MULTILINE
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

  class ProxyConfig
    include JSON::Serializable
    property cmd_name : String
    property conf_path : ConfigPathSet?
    property keys : Keyword?
    property require_setting : String?
    property after_execute : Array(String)?
  end
end
