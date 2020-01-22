# TODO: Write documentation for `Switch::Proxy`
require "clim"
require "json"
require "file_utils"
require "./switch-proxy_helper.cr"
require "./configs.cr"

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

      sub "enable" do
        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."
        desc "enable proxy setting."
        usage "swpro enable [command]"

        run do |opts, args, io|
          if opts.all
            check_arg_num opts, args, num = 0
            _command = nil
          else
            check_arg_num opts, args, num = 1
            _command = args[0]
          end

          configs = read_json SWPRO_CONF_PATH, io
          configs = configs.nil? ? return -1 : configs

          if opts.all
            configs.each do |config|
              Switch::Proxy::MyCli.start(["enable", config.cmd_name.to_s], io: io)
            end
            return 1
          end

          _command = _command.nil? ? return -1 : _command

          index = search_command configs, _command
          config = index.nil? ? return -1 : configs[index]
          path = select_path config, opts

          check_file_exists_only_check path
          check_writable path

          content = File.read path
          option = Regex::Options::MULTILINE
          content = content.gsub Regex.new(config.keys.http_proxy.disable_set.regex, option), config.keys.http_proxy.enable_set.string
          content = content.gsub Regex.new(config.keys.https_proxy.disable_set.regex, option), config.keys.https_proxy.enable_set.string

          File.write(path, content)
          io.puts "Enabled proxy settings for #{_command}."
        end
      end

      sub "disable" do
        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."

        desc "disable proxy setting."
        usage "swpro disable [command]"

        run do |opts, args, io|
          if opts.all
            check_arg_num opts, args, num = 0
            _command = nil
          else
            check_arg_num opts, args, num = 1
            _command = args[0]
          end
          configs = read_json SWPRO_CONF_PATH, io
          configs = configs.nil? ? return -1 : configs
          if opts.all
            configs.each do |config|
              Switch::Proxy::MyCli.start(["disable", config.cmd_name.to_s], io: io)
            end
            return 1
          end

          _command = _command.nil? ? return -1 : _command
          index = search_command configs, _command
          config = index.nil? ? return -1 : configs[index]
          path = select_path config, opts
          check_file_exists_only_check path, io
          check_writable path

          content = File.read path
          option = Regex::Options::MULTILINE
          content = content.gsub Regex.new(config.keys.http_proxy.enable_set.regex, option), config.keys.http_proxy.disable_set.string
          content = content.gsub Regex.new(config.keys.https_proxy.enable_set.regex, option), config.keys.https_proxy.disable_set.string

          File.write(path, content)
          io.puts "Disabled proxy settings for #{_command}."
        end
      end

      sub "set" do
        option "--system", type: Bool, desc: "applay for system."
        option "--user", type: Bool, desc: "applay for user."
        option "--all", type: Bool, desc: "applay proxy setting to all commands."

        desc "set configs."
        usage "swpro set [command] [proxy server uri]"

        run do |opts, args, io|
          if opts.all
            check_arg_num opts, args, num = 1
            _command = nil
            _url = args[0]
          else
            check_arg_num opts, args, num = 2
            _command = args[0]
            _url = args[1]
          end

          content = nil
          configs = read_json SWPRO_CONF_PATH, io
          configs = configs.nil? ? return -1 : configs

          if opts.all
            configs.each do |config|
              Switch::Proxy::MyCli.start(["set", config.cmd_name.to_s, _url], io: io)
            end
            return 1
          end

          _command = _command.nil? ? return -1 : _command
          index = search_command configs, _command

          config = index.nil? ? return -1 : configs[index]

          path = select_path config, opts

          check_file_exists path

          check_writable path
          content = set_proxy path, config, _url, io

          File.write(path, content)

          io.puts "Proxy settings are complete."
        end
      end

      sub "check" do
        desc "check swpro.json"
        usage "swpro check"

        run do |opts, args, io|
          check_arg_num opts, args, num = 0
          configs = read_json SWPRO_CONF_PATH, io
          configs = configs.nil? ? return -1 : configs
          is_vaild_json? configs, io
        end
      end

      sub "install" do
        desc "install swpro to system"
        usage "sudo swpro install"

        run do |opts, args, io|
          Switch::Proxy::MyCli.start(["internal_commands", "symlink"], io: io)
          Switch::Proxy::MyCli.start(["internal_commands", "cp_json"], io: io)
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
            src = Path["./.swpro.json"].normalize.expand(home: true)
            dest = Path["~/.swpro.json"].normalize.expand(home: true)
            cp src: src, dest: dest, io: io
          end
        end

        sub "symlink" do
          desc "create symlink."
          usage "swpro symlink"

          run do |opts, args, io|
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
        end
      end
    end
  end
end
