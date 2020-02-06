require "json"

def enable(opts, args, io)
  if opts.all
    check_arg_num opts, args, num = 0
    _command = nil
  else
    check_arg_num opts, args, num = 1
    _command = args[0]
  end

  configs = read_json SWPRO_CONF_PATH, io
  configs = configs.nil? ? return -1 : configs

  if opts.all
    configs.each do |config|
      Switch::Proxy::MyCli.start(["enable", config.cmd_name.to_s], io: io)
    end
    return 1
  end

  _command = _command.nil? ? return -1 : _command

  index = search_command configs, _command
  config = index.nil? ? return -1 : configs[index]
  path = select_path config, opts

  check_file_exists_only_check path
  check_writable path

  content = File.read path
  option = Regex::Options::MULTILINE
  content = content.gsub Regex.new(config.keys.http_proxy.disable_set.regex, option), config.keys.http_proxy.enable_set.string
  content = content.gsub Regex.new(config.keys.https_proxy.disable_set.regex, option), config.keys.https_proxy.enable_set.string

  File.write(path, content)
  io.puts "Enabled proxy settings for #{_command}."
end
