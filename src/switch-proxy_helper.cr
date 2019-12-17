require "./configs.cr"

def check_writable(path : Path)
  if (!File.writable? path)
    puts "#{path}に書き込みできません (>_<) 権限を確認してください"
    abort()
  end
end

def check_readable(path : Path)
  if (!File.readable? path)
    puts "#{path}を読めません (>_<) 権限を確認してください"
    abort()
  end
end

def check_arg_num(opts, args, num)
  if (args.size < num)
    puts "引数を確認してください (>_<)"
    puts opts.help_string
    abort()
  end
end

def check_file_exists(path : Path)
  if (!File.file? path)
    file = File.new(path, "w")
    file.close
    puts "#{path}が存在しなかったので、新規作成しました"
  end
end

def set_proxy(path : Path, config : Config, url : String, io : IO) : String
  check_writable path
  check_file_exists path

  content = File.read path
  regex_set_http = config.keys.http_proxy
  regex_set_https = config.keys.https_proxy

  content = set_value(path, content, regex_set_http, url, io)
  content = set_value(path, content, regex_set_https, url, io)
  return content
end

def set_value(path : Path, content : String, config : OptionSet, url : String, io : IO) : String
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

    content = content.gsub(regex, "#{config.enable_set.string} #{url};")
    io.puts "書き換えました｡"
  end

  return content
end

def search_command(configs : Array(Config), command : String) : Int32
  i = 0
  configs.each do |config|
    if (config.cmd_name == command)
      return i
    end
    i += 1
  end
  if i == configs.size
    puts "Jsonに#{command}の設定の記述は見つかりませんでした (>_<)"
    abort()
  end
  return i
end
