def install(opts, args, io)
  Switch::Proxy::MyCli.start(["internal_commands", "symlink"], io: io)
  Switch::Proxy::MyCli.start(["internal_commands", "cp_json"], io: io)
end
