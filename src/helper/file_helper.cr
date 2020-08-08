require "./io_helper.cr"
require "../config/user_config"
require "../config/proxy_list"

module Switch::Proxy::Helper::FileHelper
  extend self
  include Switch::Proxy::Helper::IOHelper
  include  Switch::Proxy::Config::ProxyConfig
  include Switch::Proxy::Config::UserConfig

  def check_writable(path : Path, io : IO = STDOUT)
    if (!File.writable? path)
      string = error "Cannot write to #{path.to_s.colorize.underline}. Check permissions."
      io.puts string
      abort
    end
  end

  def check_readable(path : Path, io : IO = STDOUT)
    if (!File.readable? path)
      string = error "Unable to read #{path.to_s.colorize.underline}. Check permissions."
      io.puts string
      abort
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
      Dir.mkdir_p path.parent
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
    io.puts info "#{src.to_s.colorize.underline} copied to #{dest.to_s.colorize.underline}"
  end

  def read_proxy_configs_from_json(path : Path, io : IO) : Array(ProxyConfig)?
    begin
      return Array(ProxyConfig).from_json(File.read path)
    rescue ex
      io.puts error "Failed to read #{path.to_s.colorize.underline}. Check the format of the json file."
      io.puts ex.message
      return nil
    end
  end

  def read_user_config_from_json(path : Path, io : IO) : UserConfig?
    begin
      return UserConfig.from_json(File.read path)
    rescue ex
      io.puts error "Failed to read #{path.to_s.colorize.underline}. Check the format of the json file."
      io.puts ex.message
      return nil
    end
  end

  def write_conf_file(path : Path, content : String?, io)
    if content
      backup_dir_path = "#{path.parent}/.#{path.basename}.backup.d"
      backup_file_path = Path.new("#{backup_dir_path}/#{path.basename}.#{Time.local.to_s("%Y-%m-%d.%H-%M-%S")}.bak")

      if !Dir.exists? backup_dir_path
        Dir.mkdir_p backup_dir_path
      end
      
      cp path, backup_file_path, io
      File.write(path, content)
    else
      abort error "Prevented an empty string from being written to the #{path.to_s.colorize.underline}"
    end
  end
end
