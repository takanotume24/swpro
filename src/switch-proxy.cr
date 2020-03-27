# TODO: Write documentation for `Switch::Proxy`
require "clim"
require "json"
require "file_utils"
require "./switch-proxy_helper.cr"
require "./configs.cr"
require "./commands/*"
require "./commands/internal_commands/*"

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
        desc "execute command with proxy setting."
        usage "swpro execute [command] [args]"

        run do |opts, args, io|
          execute opts, args, io
        end
      end

      sub "enable" do
        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."
        desc "enable proxy setting."
        usage "swpro enable [command]"

        run do |opts, args, io|
          enable opts, args, io
        end
      end

      sub "disable" do
        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."

        desc "disable proxy setting."
        usage "swpro disable [command]"

        run do |opts, args, io|
          disable opts, args, io
        end
      end

      sub "set" do
        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."

        desc "set configs."
        usage "swpro set [command] [proxy server uri]"

        run do |opts, args, io|
          set opts, args, io
        end
      end

      sub "check" do
        desc "check swpro.json"
        usage "swpro check"

        run do |opts, args, io|
          check opts, args, io
        end
      end

      sub "install" do
        desc "install swpro to system"
        usage "sudo swpro install"

        run do |opts, args, io|
          install opts, args, io
        end
      end

      sub "internal_commands" do
        desc "This is a command used for internal processing."
        usage "swpro internal_commands [command]"

        run do |opts, args, io|
          io.puts opts.help_string
        end

        sub "cp_json" do
          desc "copy json to ~/.swpro.json"
          usage "swpro cp_json"

          run do |opts, args, io|
            cp_json opts, args, io
          end
        end

        sub "symlink" do
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
