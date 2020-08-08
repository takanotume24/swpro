module Switch::Proxy::Commands
  extend self 
  include Switch::Proxy::Config

  def disable(opts, args, io)
    _command = args.target_command
    proxy_configs = read_proxy_configs_from_json ProxyConfig.get_path, io
    user_config = read_user_config_from_json UserConfig.get_path, io

    if proxy_configs.nil?
      abort
    end
    if user_config.nil?
      abort
    end

    if _command == "all"
      proxy_configs.each do |config|
        Switch::Proxy::MyCli.start(["disable", config.cmd_name.to_s], io: io)
      end
      return 1
    end

    index = search_command proxy_configs, _command
    if index.nil?
      abort
    end
    config = proxy_configs[index]

    if config.require_setting
      Switch::Proxy::MyCli.start(["disable", config.require_setting.to_s], io: io)
    end

    path = select_path config, opts

    if path.nil?
      abort
    end

    check_file_exists_only_check path, io
    check_writable path

    content = File.read path

    keys = config.keys

    if keys.nil?
      abort
    end

    http_string = keys.http_proxy.disable_set.string.gsub user_config.replacement, user_config.domain
    https_string = keys.https_proxy.disable_set.string.gsub user_config.replacement, user_config.domain
    puts content.scan(keys.http_proxy.enable_set.regex)
    puts content.scan(keys.https_proxy.enable_set.regex)
    puts keys.http_proxy.enable_set.regex
    puts keys.https_proxy.enable_set.regex

    content = content.gsub keys.http_proxy.enable_set.regex, http_string
    content = content.gsub keys.https_proxy.enable_set.regex, https_string
    write_conf_file(path, content, io)

    after_execute = config.after_execute
    if after_execute
      io.puts "[EXEC]\t #{after_execute}"
      after_execute.each do |command|
        system command
      end
    end

    io.puts "[INFO]\t Disabled proxy settings for #{_command}."
  end
end
