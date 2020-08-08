require "../helper/*"

module Switch::Proxy::Commands
  include Switch::Proxy::Helper::Common
  include Switch::Proxy::Helper::FileHelper
  include Switch::Proxy::Config::ProxyConfig

  def check(opts, args, io)    
    configs = read_proxy_configs_from_json SWPRO_PROXY_LIST_PATH, io

    if configs.nil?
      abort
    end
    is_vaild_json? configs, io
  end
end
