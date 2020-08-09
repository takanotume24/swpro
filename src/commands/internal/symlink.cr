module Switch::Proxy::Commands::Internal
  extend self
  include Switch::Proxy::Helper::Common

  def symlink(opts, args, io)
    new_path = Path["/bin/swpro"].normalize.expand(home: true).to_s
    old_path = Path["./bin/swpro"].normalize.expand(home: true).to_s
    if File.file? new_path
      io.puts info "Symbolic link already exists."
      return -1
    end
    if !File.file? old_path
      io.puts "[ERROR]\t #{old_path} does not exist."
      return -1
    end
    File.symlink old_path, new_path
  end
end
