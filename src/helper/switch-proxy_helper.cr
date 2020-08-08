require "./../configs.cr"

module Switch::Proxy::Helper::Common
  def check_arg_num(opts, args, num, io : IO = STDOUT)
    if (args.size < num)
      io.puts "[ERROR]\t Check the arguments."
      io.puts opts.help_string
      abort
    end
  end

  def set_proxy(path : Path, config : Config, url : String, io : IO = STDOUT) : String?
    check_writable path
    check_file_exists path

    content = File.read path
    keys = config.keys

    case
    when keys.nil?
      io.puts "[ERROR]\t \"keys\" of \"#{config.cmd_name}\" is null."
    else
      content = set_value(path, content, keys.http_proxy, url, io)
      content = set_value(path, content, keys.https_proxy, url, io)
      return content
    end
    return nil
  end

  def set_value(path : Path, content : String, option_set : OptionSet, url : String, io : IO = STDOUT) : String
    regex = option_set.enable_set.regex
    match_data = content.scan(regex)
    new_line = option_set.enable_set.string.gsub "REPLACEMENT", url

    if match_data.size == 0
      content += new_line
      io.puts "[INFO]\t Added: #{new_line}"
      return content
    end

    if match_data.size > 0
      printf "[INFO]\t in #{path}, #{match_data} already exists. Do you want to rewrite? (y/n)?: "

      if read_line != "y"
        io.puts "[INFO]\t Did not rewrite."
        return content
      end

      content = content.gsub(regex, new_line)
      io.puts "[INFO]\t Rewritten."
    end

    return content
  end

  def search_command(configs : Array(Config), command : String, io : IO = STDOUT) : Int32?
    i = 0
    configs.each do |config|
      if (config.cmd_name == command)
        return i
      end
      i += 1
    end
    if i == configs.size
      io.puts "[ERROR]\t #{command} is not supported."
      return nil
    end
    return i
  end

  def select_path(config : Config, opts) : Path?
    conf_path = config.conf_path
    if conf_path
      system = conf_path.system
      user = conf_path.user

      case opts
      when .system
        if system
          return Path[system].normalize.expand(home: true)
        end
      when .user
        if user
          return Path[user].normalize.expand(home: true)
        end
      end

      case
      when user
        return Path[user].normalize.expand(home: true)
      when system
        return Path[system].normalize.expand(home: true)
      else
        abort "[ERROR]\t There is no system configuration path or user configuration path set for \"#{config.cmd_name}\" "
      end
    end
  end

  def is_vaild_json?(configs : Array(Config), io : IO) : Bool
    i = 0
    result = false
    configs.each do |config|
      conf_path = config.conf_path

      case
      when conf_path && conf_path.user.nil? && conf_path.system.nil?
        io.puts "[ERROR]\t No.#{i} conf_path.user and conf_path.system are empty"
      when config.cmd_name.to_s.empty?
        io.puts "[ERROR]\t No.#{i} cmd_name is empty."
      else
        io.puts "[INFO]\t No.#{i},\tThere was no problem with [#{config.cmd_name}]."
        result = true
      end

      i += 1
    end
    return result
  end
end
