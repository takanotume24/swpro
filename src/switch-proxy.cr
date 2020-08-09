# TODO: Write documentation for `Switch::Proxy`
require "clim"
require "json"
require "file_utils"
require "./config/**"
require "./commands/**"
require "./helper/**"

module Switch::Proxy
  VERSION = "0.2.3"

  class MyCli < Clim
    main do
      desc "proxy setting helper."
      usage "swpro [sub_command] [arguments]"
      help short: "-h"

      run do |opts, args, io|
        io.puts opts.help_string
      end

      sub "execute" do
        include Switch::Proxy::Commands

        desc "execute command with proxy setting."
        usage "swpro execute [command] [args]"

        run do |opts, args, io|
          execute opts, args, io
        end
      end

      sub "enable" do
        include Switch::Proxy::Commands

        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."
        desc "enable proxy setting."
        usage "swpro enable [command]"

        argument "target-command",
          desc: "Command name to enable the proxy． \"all\"=All the commands registered in swpro will be targeted.",
          type: String,
          required: true

        run do |opts, args, io|
          enable opts, args, io
        end
      end

      sub "disable" do
        include Switch::Proxy::Commands

        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."

        desc "disable proxy setting."
        usage "swpro disable [command]"

        argument "target-command",
          desc: "Command name to disable the proxy． \"all\"=All the commands registered in swpro will be targeted.",
          type: String,
          required: true

        run do |opts, args, io|
          disable opts, args, io
        end
      end

      sub "set" do
        include Switch::Proxy::Commands

        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."

        desc "set configs."
        usage "swpro set [command] [proxy server uri]"

        argument "target-command",
          desc: "Command name to set the proxy． \"all\"=All the commands registered in swpro will be targeted.",
          type: String,
          required: true

        argument "url",
          desc: "Proxy Server URL",
          type: String,
          required: true

        run do |opts, args, io|
          set opts, args, io
        end
      end

      sub "check" do
        include Switch::Proxy::Commands

        desc "Check the format of the json file."
        usage "swpro check"

        run do |opts, args, io|
          check opts, args, io
        end
      end

      sub "install" do
        include Switch::Proxy::Commands

        desc "install swpro to system"
        usage "sudo swpro install"

        run do |opts, args, io|
          install opts, args, io
        end
      end

      sub "internal" do
        desc "This is a command used for internal processing."
        usage "swpro internal [command]"

        run do |opts, args, io|
          io.puts opts.help_string
        end

        sub "cp_json" do
          include Switch::Proxy::Commands::Internal

          desc "copy json to ~/.swpro.json"
          usage "swpro cp_json"

          run do |opts, args, io|
            cp_json opts, args, io
          end
        end

        sub "symlink" do
          include Switch::Proxy::Commands::Internal

          desc "create symlink."
          usage "swpro symlink"

          run do |opts, args, io|
            symlink opts, args, io
          end
        end
      end
    end
  end
end
