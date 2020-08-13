module Switch::Proxy::Commands::Internal
  extend self
  include Switch::Proxy::Helper::Common

  def symlink(opts, args, io)
    process_path = Process.executable_path
    if process_path.nil?
      io.puts error "Cannot get Process.executable_path."
      return nil
    end

    process_path = Path[process_path]

    new_path = Path["/", "bin", "swpro"].normalize.expand(home: true).to_s
    old_path = process_path.normalize.expand(home: true).to_s
    if File.file? new_path
      io.puts info "Symbolic link already exists."
      return -1
    end
    if !File.file? old_path
      io.puts error "#{old_path} does not exist."
      return -1
    end
    File.symlink old_path, new_path
  end
end
