# TODO: Write documentation for `Switch::Proxy`
require "clim"
require "json"
require "./switch-proxy_helper.cr"
require "./configs.cr"

module Switch::Proxy
  VERSION = "0.1.0"

  class MyCli < Clim
    main do
      desc "proxy setting tool."
      usage "swpro [sub_command] [arguments]"
      help short: "-h"

      run do |opts, args, io|
        io.puts opts.help_string
      end

      sub "enable" do
        desc "enable proxy setting"
        usage "swpro enable [command]"

        run do |opts, args, io|
          check_arg_num opts, args, num = 1

          _command = args[0]
          configs = Array(Config).from_json(File.read "./config.json")
          index = search_command configs, _command
          config = configs[index]
          path = Path[config.conf_path].normalize.expand(home: true)

          content = File.read path
          content = content.gsub Regex.new(config.keys.http_proxy.disable_set.regex), config.keys.http_proxy.enable_set.string
          content = content.gsub Regex.new(config.keys.https_proxy.disable_set.regex), config.keys.https_proxy.enable_set.string

          File.write(path, content)
          io.puts "#{_command}のプロキシ設定を有効化しました｡ (^_^)"
        end
      end

      sub "disable" do
        desc "disable proxy setting"
        usage "swpro disable [command]"

        run do |opts, args, io|
          check_arg_num opts, args, num = 1

          _command = args[0]
          configs = Array(Config).from_json(File.read "./config.json")
          index = search_command configs, _command
          config = configs[index]
          path = Path[config.conf_path].normalize.expand(home: true)

          content = File.read path
          content = content.gsub Regex.new(config.keys.http_proxy.enable_set.regex), config.keys.http_proxy.disable_set.string
          content = content.gsub Regex.new(config.keys.https_proxy.enable_set.regex), config.keys.https_proxy.disable_set.string

          File.write(path, content)
          io.puts "#{_command}のプロキシ設定を無効化しました｡ (^_^)"
        end
      end

      sub "set" do
        desc "set configs"
        usage "swpro set [command] [proxy server uri]"

        run do |opts, args, io|
          check_arg_num opts, args, num = 2

          _command = args[0]
          _url = args[1]

          content = nil
          configs = Array(Config).from_json(File.read "./config.json")
          index = search_command configs, _command

          config = configs[index]
          path = Path[config.conf_path].normalize.expand(home: true)

          check_file_exists path

          check_writable path
          content = set_proxy path, config, _url, io

          File.write(path, content)

          io.puts "プロキシ設定が完了しました｡ (^_^)"
        end
      end
    end
  end
end
