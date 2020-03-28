def set(opts, args, io)
  if opts.all
    check_arg_num opts, args, num = 1
    _url = args[0]
  else
    check_arg_num opts, args, num = 2
    _command = args[0]
    _url = args[1]
  end

  configs = read_json SWPRO_CONF_PATH, io

  if configs.nil?
    abort
  end

  if opts.all
    configs.each do |config|
      Switch::Proxy::MyCli.start(["set", config.cmd_name.to_s, _url], io: io)
    end
    return 1
  end

  safe _command, index = search_command configs, _command
  safe index, config = configs[index]

  if config.nil?
    abort
  end

  path = select_path config, opts

  if path.nil?
    abort
  end

  check_file_exists path

  check_writable path
  content = set_proxy path, config, _url, io

  write_conf_file path, content, io

  io.puts "Proxy settings are complete."
end
