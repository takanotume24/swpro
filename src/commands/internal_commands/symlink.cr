def symlink(opts, args, io)
  check_arg_num opts, args, num = 0
  new_path = Path["/bin/swpro"].normalize.expand(home: true).to_s
  old_path = Path["./bin/swpro"].normalize.expand(home: true).to_s
  if File.file? new_path
    io.puts "Symbolic link already exists."
    return -1
  end
  if !File.file? old_path
    io.puts "[error] #{old_path} does not exist."
    return -1
  end
  File.symlink old_path, new_path
end