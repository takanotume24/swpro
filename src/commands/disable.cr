module Switch::Proxy::Commands
  def disable(opts, args, io)
    _command = args.target_command
    configs = read_json SWPRO_CONF_PATH, io

    if configs.nil?
      abort
    end

    if _command == "all"
      configs.each do |config|
        Switch::Proxy::MyCli.start(["disable", config.cmd_name.to_s], io: io)
      end
      return 1
    end

    index = search_command configs, _command
    if index.nil?
      abort
    end
    config = configs[index]

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
    option = Regex::Options::MULTILINE

    keys = config.keys

    if keys.nil?
      abort
    end

    content = content.gsub keys.http_proxy.enable_set.regex, keys.http_proxy.disable_set.string
    content = content.gsub keys.https_proxy.enable_set.regex, keys.https_proxy.disable_set.string
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
