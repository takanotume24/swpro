require "./../config/proxy_list.cr"

module Switch::Proxy::Helper::Common
  extend self
  include Switch::Proxy::Config
  include Switch::Proxy::Helper::IOHelper
  
  def set_proxy(path : Path, config : ProxyConfig::ProxyConfig, url : String, io : IO = STDOUT) : String?
    check_writable path
    check_file_exists path

    content = File.read path
    keys = config.keys

    case
    when keys.nil?
      io.puts error "\"keys\" of \"#{config.cmd_name}\" is null."
    else
      content = set_value(path, content, keys.http_proxy, url, io)
      if content.nil?
        return nil
      end
      content = set_value(path, content, keys.https_proxy, url, io)
      if content.nil?
        return nil
      end
      return content
    end
    return nil
  end

  def set_value(path : Path, content : String, option_set : ProxyConfig::OptionSet, url : String, io : IO = STDOUT) : String?
    regex = option_set.enable_set.regex
    match_data = content.scan(regex)
    user_config = read_user_config_from_json UserConfig.get_path, io
    if user_config.nil?
      io.puts error "#{UserConfig.get_path.colorize.underline} is Nil."
      return nil
    end

    new_line = option_set.enable_set.string.gsub user_config.replacement, url

    if match_data.size == 0
      content += new_line + "\n"
      io.puts info "Added: #{new_line}"
      return content
    end

    if match_data.size > 0
      printf info "in #{path}, #{match_data} already exists. Do you want to rewrite? (y/n)?: "

      if read_line != "y"
        io.puts info "Did not rewrite."
        return content
      end

      content = content.gsub(regex, new_line)
      io.puts info "Rewritten."
    end

    return content
  end

  def search_command(configs : Array(ProxyConfig::ProxyConfig), command : String, io : IO = STDOUT) : Int32?
    i = 0
    configs.each do |config|
      if (config.cmd_name == command)
        return i
      end
      i += 1
    end
    if i == configs.size
      io.puts error "#{command} is not supported."
      return nil
    end
    return i
  end

  def select_path(config : ProxyConfig::ProxyConfig, opts, io : IO) : Path?
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
        io.puts error "There is no system configuration path or user configuration path set for \"#{config.cmd_name}\" "
        return nil
      end
    end
  end

  def is_vaild_json?(configs : Array(ProxyConfig::ProxyConfig), io : IO) : Bool
    i = 0
    result = false
    configs.each do |config|
      conf_path = config.conf_path

      case
      when conf_path && conf_path.user.nil? && conf_path.system.nil?
        io.puts error "No.#{i} conf_path.user and conf_path.system are empty"
      when config.cmd_name.to_s.empty?
        io.puts error "No.#{i} cmd_name is empty."
      else
        io.puts info "No.#{i},\tThere was no problem with [#{config.cmd_name}]."
        result = true
      end

      i += 1
    end
    return result
  end

  def is_vaild_json?(config : UserConfig::UserConfig, io : IO) : Bool
    if config.domain.nil?
      io.puts error "in #{UserConfig.get_path}, \"domain\" must not be null."
      io.puts error "Register the proxy server with #{"swpro set all".colorize.bold}."
      false
    else
      true
    end
  end
end
