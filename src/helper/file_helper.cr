module Switch::Proxy::Helper::FileHelper
  def check_writable(path : Path, io : IO = STDOUT)
    if (!File.writable? path)
      io.puts "[ERROR]\t Cannot write to #{path}. Check permissions."
      abort
    end
  end

  def check_readable(path : Path, io : IO = STDOUT)
    if (!File.readable? path)
      io.puts "[ERROR]\t Unable to read #{path}. Check permissions."
      abort
    end
  end

  def check_file_exists_only_check(path : Path, io : IO = STDOUT) : Bool
    if (!File.file? path)
      io.puts "[ERROR]\t #{path} does not exist."
      return false
    end
    return true
  end

  def check_file_exists(path : Path, io : IO = STDOUT)
    if (!File.file? path)
      file = File.new(path, "w")
      file.close
      io.puts "[INFO]\t #{path} did not exist, so it was created."
    end
  end

  def cp(src : Path, dest : Path, io : IO)
    if File.file? dest
      io.printf "[INFO]\t #{dest} already exists. Overwrite with #{src} ?(y/n)"
      ans = read_line

      case ans
      when "y"
      else
        io.puts "[INFO]\t Canceled."
        return
      end
    end

    FileUtils.cp src_path: src.to_s, dest: dest.to_s
    io.puts "[INFO]\t #{src} copied to #{dest}"
  end

  def read_json(path : Path, io : IO) : Array(Config)?
    begin
      return Array(Config).from_json(File.read path)
    rescue ex
      io.puts "[ERROR]\t Failed to read #{path}. Check the format of the json file."
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
      abort "[ERROR]\t Prevented an empty string from being written to the #{path}"
    end
  end
end
