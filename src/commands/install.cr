module Switch::Proxy::Commands
  def install(opts, args, io)
    Switch::Proxy::MyCli.start(["internal", "symlink"], io: io)
    Switch::Proxy::MyCli.start(["internal", "cp_json"], io: io)
  end
end
