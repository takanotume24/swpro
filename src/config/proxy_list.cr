require "json"
require "./user_config"

module Switch::Proxy::Config::ProxyConfig
  extend self

  def get_path
    Path["~/.swpro/proxy_list.json"].normalize.expand(home: true)
  end
  
  def Regex.new(pull : JSON::PullParser)
    user_conf_file = File.read Switch::Proxy::Config::UserConfig.get_path

    user_config = Switch::Proxy::Config::UserConfig::UserConfig.from_json(user_conf_file)
    string = pull.read_string.gsub user_config.replacement, user_config.domain
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
