require "../helper/*"

module Switch::Proxy::Commands
  extend self
  include Switch::Proxy::Helper::Common
  include Switch::Proxy::Helper::FileHelper
  include Switch::Proxy::Config

  def check(opts, args, io)    
    configs = read_proxy_configs_from_json ProxyConfig.get_path, io

    if configs.nil?
      return nil
    end
  end
end
