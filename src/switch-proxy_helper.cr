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

def set_proxy(path : Path, config : Config, url : String, io : IO = STDOUT) : String
  check_writable path
  check_file_exists path

  content = File.read path
  regex_set_http = config.keys.http_proxy
  regex_set_https = config.keys.https_proxy

  content = set_value(path, content, regex_set_http, config.quotation, url, config.row_end, io)
  content = set_value(path, content, regex_set_https, config.quotation, url, config.row_end, io)
  return content
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

def select_path(config, opts) : Path
  case opts
  when .system
    return Path[config.conf_path.system].normalize.expand(home: true)
  when .user
    return Path[config.conf_path.system].normalize.expand(home: true)
  end

  case
  when config.conf_path.system.empty?
    return Path[config.conf_path.user].normalize.expand(home: true)
  when config.conf_path.user.empty?
    return Path[config.conf_path.system].normalize.expand(home: true)
  else
    return Path[config.conf_path.user].normalize.expand(home: true)
  end
end

def is_vaild_json?(configs : Array(Config), io : IO) : Bool
  i = 0
  result = false
  configs.each do |config|
    case
    when config.cmd_name.to_s.empty?
      io.puts "[error] No.#{i} cmd_name is empty."
    when config.conf_path.system.empty? && config.conf_path.user.empty?
      io.puts "[error] No.#{i} conf_path.system and conf_path.user are empty"
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
  io.puts "#{src} copied to #{dest}."
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
