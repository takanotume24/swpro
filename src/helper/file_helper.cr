require "./io_helper.cr"
require "./switch-proxy_helper"
require "../config/user_config"
require "../config/proxy_list"

module Switch::Proxy::Helper::FileHelper
  extend self
  include Switch::Proxy::Helper::IOHelper
  include Switch::Proxy::Helper::Common
  include Switch::Proxy::Config

  def check_writable(path : Path, io : IO = STDOUT)
    if (!File.writable? path)
      string = error "Cannot write to #{path.to_s.colorize.underline}. Check permissions."
      io.puts string
      return nil
    end
  end

  def check_readable(path : Path, io : IO = STDOUT)
    if (!File.readable? path)
      string = error "Unable to read #{path.to_s.colorize.underline}. Check permissions."
      io.puts string
      return nil
    end
  end

  def check_file_exists_only_check(path : Path, io : IO = STDOUT) : Bool
    if (!File.file? path)
      io.puts error "#{path.to_s.colorize.underline} does not exist."
      return false
    end
    return true
  end

  def check_file_exists(path : Path, io : IO = STDOUT)
    if (!File.file? path)
      mkdir_p path.parent
      file = File.new(path, "w")
      file.close
      io.puts info "#{path.to_s.colorize.underline} did not exist, so it was created."
    end
  end

  def cp(src : Path, dest : Path, io : IO)
    if File.file? dest
      io.printf info "#{dest.to_s.colorize.underline} already exists. Overwrite with #{src.to_s.colorize.underline} ?(y/n)"
      ans = read_line

      case ans
      when "y"
      else
        io.puts info "Canceled."
        return
      end
    end

    FileUtils.cp src_path: src.to_s, dest: dest.to_s
    chown_when_sudo dest
    io.puts info "#{src.to_s.colorize.underline} copied to #{dest.to_s.colorize.underline}"
  end

  def mkdir_p(path : Path)
    Dir.mkdir_p path
    chown_when_sudo path
  end

  def read_proxy_configs_from_json(path : Path, io : IO, verbose = false) : Array(ProxyConfig::ProxyConfig)?
    begin
      config = Array(ProxyConfig::ProxyConfig).from_json(File.read path)
      if is_vaild_json? config, io, verbose
        return config
      else
        return nil
      end
    rescue ex
      io.puts error "Failed to read #{path.to_s.colorize.underline}. Check the format of the json file."
      io.puts ex.message
      return nil
    end
  end

  def read_user_config_from_json(path : Path, io : IO) : UserConfig::UserConfig?
    begin
      config = UserConfig::UserConfig.from_json(File.read path)
      if is_vaild_json? config, io
        return config
      else
        return nil
      end
    rescue ex
      io.puts error "Failed to read #{path.to_s.colorize.underline}. Check the format of the json file."
      io.puts ex.message
      return nil
    end
  end

  def write_json(config : UserConfig::UserConfig)
    File.write UserConfig.get_path, config.to_json
    chown_when_sudo UserConfig.get_path
  end

  def write_conf_file(path : Path, content : String?, io)
    if content
      backup_dir_path = "#{path.parent}/.#{path.basename}.backup.d"
      backup_file_path = Path.new("#{backup_dir_path}/#{path.basename}.#{Time.local.to_s("%Y-%m-%d.%H-%M-%S-%9N")}.bak")

      if !Dir.exists? backup_dir_path
        Dir.mkdir_p backup_dir_path
      end

      cp path, backup_file_path, io
      File.write(path, content)
      chown_when_sudo path
    else
      io.puts error "Prevented an empty string from being written to the #{path.to_s.colorize.underline}"
      return nil
    end
  end

  def chown_when_sudo(path : Path)
    # ホームフォルダ以下にfileが存在するのであれば，chown user

    sudo_user = ENV["SUDO_USER"]?
    if sudo_user.nil?
      return
    end
    whoami = `whoami`.delete '\n'
    uid = `id -u $SUDO_USER`.to_i
    gid = `id -g $SUDO_USER`.to_i
    parent_dir_user_name = `stat -c %U #{path.parent}`.delete '\n'
    parent_dir_group = `stat -c %G #{path.parent}`.delete '\n'

    # sudo で実行している時
    if whoami == "root" && whoami != sudo_user
      if parent_dir_user_name != whoami
        File.chown path, uid, gid
      end
    end
  end
end
