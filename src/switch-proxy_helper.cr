require "./configs.cr"

def check_writable(path : Path, io : IO = STDOUT)
  if (!File.writable? path)
    io.puts "#{path}に書き込みできません (>_<) 権限を確認してください"
    abort
  end
end

def check_readable(path : Path, io : IO = STDOUT)
  if (!File.readable? path)
    io.puts "#{path}を読めません (>_<) 権限を確認してください"
    abort
  end
end

def check_arg_num(opts, args, num, io : IO = STDOUT)
  if (args.size < num)
    io.puts "引数を確認してください (>_<)"
    io.puts opts.help_string
    abort
  end
end

def check_file_exists_only_check(path : Path, io : IO = STDOUT) : Bool
  if (!File.file? path)
    io.puts "#{path}が存在しません"
    return false
  end
  return true
end

def check_file_exists(path : Path, io : IO = STDOUT)
  if (!File.file? path)
    file = File.new(path, "w")
    file.close
    io.puts "#{path}が存在しなかったので、新規作成しました"
  end
end

def set_proxy(path : Path, config : Config, url : String, io : IO = STDOUT) : String
  check_writable path
  check_file_exists path

  content = File.read path
  regex_set_http = config.keys.http_proxy
  regex_set_https = config.keys.https_proxy

  content = set_value(path, content, regex_set_http, url, config.row_end, io)
  content = set_value(path, content, regex_set_https, url, config.row_end, io)
  return content
end

def set_value(path : Path, content : String, config : OptionSet, url : String, file_end : String, io : IO = STDOUT) : String
  regex = Regex.new(config.enable_set.regex + ".*")
  match_data = content.scan(regex)

  if match_data.size == 0
    new_line = "#{config.enable_set.string} #{url};\n"
    content += new_line
    io.puts "追加しました｡: #{new_line}"
    return content
  end

  if match_data.size > 0
    printf "既に#{match_data}が存在します 書き換えますか(y/n)?"

    if read_line != "y"
      io.puts "書き換えませんでした｡"
      return content
    end

    content = content.gsub(regex, "#{config.enable_set.string} #{url}")
    io.puts "書き換えました｡"
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
    io.puts "#{command}には対応していません"
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
  else
    return Path[config.conf_path.system].normalize.expand(home: true)
  end
end

def is_vaild_json?(configs : Array(Config), io : IO) : Bool
  i = 0
  result = false
  configs.each do |config|
    case
    when config.cmd_name.to_s.empty?
      io.puts "[error] #{i}番目のcmd_nameがemptyです"
    when config.conf_path.system.empty? && config.conf_path.user.empty?
      io.puts "[error] #{i}番目のconf_path.systemとconf_path.userがemptyです"
    else
      io.puts "#{i}番目に問題はありませんでした"
      result = true
    end
    i += 1
  end

  return result
end

def cp(src : Path, dest : Path, io : IO)
  if File.file? dest
    io.printf "既に#{dest}は存在します｡#{src}で上書きしますか?(y/n)"
    ans = read_line

    case ans
    when "y"
    else
      io.puts "キャンセルしました"
      return
    end
  end

  FileUtils.cp src_path: src.to_s, dest: dest.to_s
  io.puts "#{src}を#{dest}へコピーしました"
end
