def set(opts, args, io)
  if opts.all
    check_arg_num opts, args, num = 1
    _command = nil
    _url = args[0]
  else
    check_arg_num opts, args, num = 2
    _command = args[0]
    _url = args[1]
  end

  configs = read_json SWPRO_CONF_PATH, io
  configs = configs.nil? ? return -1 : configs

  if opts.all
    configs.each do |config|
      Switch::Proxy::MyCli.start(["set", config.cmd_name.to_s, _url], io: io)
    end
    return 1
  end

  _command = _command.nil? ? return -1 : _command
  index = search_command configs, _command

  config = index.nil? ? return -1 : configs[index]

  path = select_path config, opts

  check_file_exists path

  check_writable path
  content = set_proxy path, config, _url, io

  write_conf_file path, content, config.cmd_name, io

  io.puts "Proxy settings are complete."
end
