require "json"
require "uri"

module Switch::Proxy::Config::UserConfig
  SWPRO_USER_CONFIG_PATH = Path["~/.swpro/user_config.json"].normalize.expand(home: true)

  def URI.new(pull : JSON::PullParser)
    parse pull.read_string
  end

  class UserConfig
    include JSON::Serializable
    property domain : URI
  end
end
