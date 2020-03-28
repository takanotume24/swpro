def disable(opts, args, io)
  if opts.all
    check_arg_num opts, args, num = 0
  else
    check_arg_num opts, args, num = 1
    _command = args[0]
  end
  configs = read_json SWPRO_CONF_PATH, io

  if configs.nil?
    abort
  end

  if opts.all
    configs.each do |config|
      Switch::Proxy::MyCli.start(["disable", config.cmd_name.to_s], io: io)
    end
    return 1
  end

  safe _command, index = search_command configs, _command
  safe index, config = configs[index]
  if config.nil?
    abort
  end

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

  content = content.gsub Regex.new(keys.http_proxy.enable_set.regex, option), keys.http_proxy.disable_set.string
  content = content.gsub Regex.new(keys.https_proxy.enable_set.regex, option), keys.https_proxy.disable_set.string
  write_conf_file(path, content, io)

  after_execute = config.after_execute
  if after_execute
    io.puts "[EXECUTE]\t #{after_execute}"
    system after_execute
  end

  io.puts "[INFO]\t Disabled proxy settings for #{_command}."
end
