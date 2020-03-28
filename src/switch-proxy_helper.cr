require "./configs.cr"

def check_writable(path : Path, io : IO = STDOUT)
  if (!File.writable? path)
    io.puts "[error] Cannot write to #{path}. Check permissions."
    abort
  end
end

def check_readable(path : Path, io : IO = STDOUT)
  if (!File.readable? path)
    io.puts "[error] Unable to read #{path}. Check permissions."
    abort
  end
end

def check_arg_num(opts, args, num, io : IO = STDOUT)
  if (args.size < num)
    io.puts "[error] Check the arguments."
    io.puts opts.help_string
    abort
  end
end

def check_file_exists_only_check(path : Path, io : IO = STDOUT) : Bool
  if (!File.file? path)
    io.puts "[error] #{path} does not exist."
    return false
  end
  return true
end

def check_file_exists(path : Path, io : IO = STDOUT)
  if (!File.file? path)
    file = File.new(path, "w")
    file.close
    io.puts "#{path} did not exist, so it was created."
  end
end

def set_proxy(path : Path, config : Config, url : String, io : IO = STDOUT) : String?
  check_writable path
  check_file_exists path

  content = File.read path
  keys = config.keys
  quotation = config.quotation
  row_end = config.row_end

  case
  when quotation.nil?
    io.puts "[Error] \"quotation\" of \"#{config.cmd_name}\" is null."
  when row_end.nil?
    io.puts "[Error] \"row_end\" of \"#{config.cmd_name}\" is null."
  when keys.nil?
    io.puts "[Error] \"keys\" of \"#{config.cmd_name}\" is null."
  else
    content = set_value(path, content, keys.http_proxy, quotation, url, row_end, io)
    content = set_value(path, content, keys.https_proxy, quotation, url, row_end, io)
    return content
  end
  return nil
end

def set_value(path : Path, content : String, option_set : OptionSet, quotation : String, url : String, file_end : String, io : IO = STDOUT) : String
  option = Regex::Options::MULTILINE
  regex = Regex.new(option_set.enable_set.regex, option)
  match_data = content.scan(regex)

  if match_data.size == 0
    new_line = "#{option_set.enable_set.string} #{quotation}#{url}#{quotation} #{file_end}\n"
    content += new_line
    io.puts "Added: #{new_line}"
    return content
  end

  if match_data.size > 0
    printf "#{match_data} already exists. Do you want to rewrite? (y/n)?"

    if read_line != "y"
      io.puts "Did not rewrite."
      return content
    end
    newline = "#{option_set.enable_set.string} #{quotation}#{url}#{quotation} #{file_end}\n"

    content = content.gsub(regex, newline)
    io.puts "Rewritten."
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
    io.puts "#{command} is not supported."
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
      abort "[Error] There is no system configuration path or user configuration path set for \"#{config.cmd_name}\" "
    end
  end
end

def is_vaild_json?(configs : Array(Config), io : IO) : Bool
  i = 0
  result = false
  configs.each do |config|
    conf_path = config.conf_path
    case
    when conf_path
      case
      when conf_path.user.nil? && conf_path.system.nil?
        io.puts "[ERROR] No.#{i} conf_path.user and conf_path.system are empty"
      end
    when config.cmd_name.to_s.empty?
      io.puts "[ERROR] No.#{i} cmd_name is empty."
    else
      io.puts "No.#{i},\tThere was no problem with [#{config.cmd_name}]."
      result = true
    end
    i += 1
  end
  return result
end

def cp(src : Path, dest : Path, io : IO)
  if File.file? dest
    io.printf "#{dest} already exists. Overwrite with #{src} ?(y/n)"
    ans = read_line

    case ans
    when "y"
    else
      io.puts "Canceled."
      return
    end
  end

  FileUtils.cp src_path: src.to_s, dest: dest.to_s
  io.puts "#{src} copied to #{dest}"
end

def read_json(path : Path, io : IO) : Array(Config)?
  begin
    return Array(Config).from_json(File.read path)
  rescue ex
    io.puts "[error] Failed to read #{path}. Check the format of the json file."
    io.puts ex.message
    return nil
  end
end

def write_conf_file(path : Path, content : String?, io)
  if content
    backup_dir_path = "#{path.parent}/.#{path.basename}.backup.d"
    backup_file_path = Path.new("#{backup_dir_path}/#{path.basename}.#{Time.local.to_s("%Y-%m-%d.%H-%M-%S")}.bak")

    if !Dir.exists? backup_dir_path
      Dir.mkdir backup_dir_path
    end

    cp path, backup_file_path, io
    File.write(path, content)
  else
    abort "[Error] Prevented an empty string from being written to the #{path}"
  end
end

macro safe(var, content)
  if {{var}}.nil?.!
    {{content}}
  end
end
