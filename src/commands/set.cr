require "../config/user_config"

module Switch::Proxy::Commands
  include Switch::Proxy::Helper
  include Switch::Proxy::Config::UserConfig

  def set(opts, args, io)
    _command = args.target_command
    _url = args.url

    proxy_configs = read_proxy_configs_from_json SWPRO_PROXY_LIST_PATH, io
    user_config= read_user_config_from_json SWPRO_USER_CONFIG_PATH, io

    if proxy_configs.nil?
      abort
    end

    if _command == "all"
      proxy_configs.each do |config|
        Switch::Proxy::MyCli.start(["set", config.cmd_name.to_s, _url], io: io)
      end
      return 1
    end

    index = search_command proxy_configs, _command
    if index.nil?
      abort
    end
    config = proxy_configs[index]

    if config.require_setting
      Switch::Proxy::MyCli.start(["set", config.require_setting.to_s, _url], io: io)
    end

    path = select_path config, opts

    if path.nil?
      abort
    end

    check_file_exists path

    check_writable path
    content = set_proxy path, config, _url, io

    write_conf_file path, content, io

    after_execute = config.after_execute
    if after_execute
      io.puts "[EXEC]\t #{after_execute}"
      after_execute.each do |command|
        system command
      end
    end

    io.puts "[INFO]\t #{config.cmd_name}'s proxy settings are now complete"
  end
end
