require "json"
require "uri"

module Switch::Proxy::Config::UserConfig
  extend self

  def get_path
    Path["~/.swpro/user_config.json"].normalize.expand(home: true)
  end

  class URI < URI
    def initialize(pull : JSON::PullParser)
      @path = pull.read_string
      # super.parse(nil, nil, nil, pull.read_string, nil, nil, nil, nil)
    end

    def initialize(string : String)
      @path = string
    end

    def to_json(json : JSON::Builder)
      json.string(self.to_s)
    end
  end

  class UserConfig
    include JSON::Serializable
    property domain : URI?
    property replacement : String = "REPLACEMENT"

    def initialize(url : String, replacement : String = "REPLACEMENT")
      @domain = URI.new url
      @replacement = replacement
    end
  end
end
