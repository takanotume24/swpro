require "json"
require "uri"

module Switch::Proxy::Config::UserConfig
  extend self

  def get_path
    Path["~/.swpro/user_config.json"].normalize.expand(home: true)
  end

  def URI.new(pull : JSON::PullParser)
    parse pull.read_string
  end

  class UserConfig
    include JSON::Serializable
    property domain : URI
    property replacement : String = "REPLACEMENT"
  end
end
