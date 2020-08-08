require "../helper/*"

module Switch::Proxy::Commands
  extend self
  include Switch::Proxy::Helper::Common
  include Switch::Proxy::Helper::FileHelper
  include Switch::Proxy::Config::ProxyConfig

  def check(opts, args, io)    
    configs = read_proxy_configs_from_json get_path, io

    if configs.nil?
      abort
    end
    is_vaild_json? configs, io
  end
end
