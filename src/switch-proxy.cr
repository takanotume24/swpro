# TODO: Write documentation for `Switch::Proxy`
require "clim"

module Switch::Proxy
  VERSION = "0.1.0"

  class MyCli < Clim
    main do
      desc "proxy setting tool."
      usage "swpro [sub_command] [arguments]"

      run do |opts, args|
        puts opts.help_string
      end

      sub "enable" do
        desc "enable proxy setting"
        usage "swpro enable [command]"

        run do |opts, args|
          puts "proxy enabled (^_^)"
        end
      end

      sub "disable" do
        desc "disable proxy setting"
        usage "swpro disable [command]"

        run do |opts, args|
          if (args.size < 1)
            puts opts.help_string
            exit()
          end

          _command = args[0]

          case _command
          when "apt"
            path = "/etc/apt/apt.conf"
            content = File.read path

            content.gsub "Acquire::http::Proxy", "# Acquire::http::Proxy"
            content.gsub "Acquire::https::Proxy", "# Acquire::https::Proxy"
          else
            puts "このコマンドは対応していません (>_<)"
            exit()
          end
        end
      end

      sub "set" do
        desc "set configs"
        usage "swpro set [command] [proxy server uri]"

        run do |opts, args|
          if (args.size < 2)
            puts opts.help_string
            exit()
          end

          _command = args[0]
          _url = args[1]

          case _command
          when "apt"
            path = "./apt.conf"

            if (!File.writable? path)
              puts "#{path}に書き込みできません (>_<) 権限を確認してください"
              exit()
            end

            if (!File.file? path)
              file = File.new(path, "w")
              file.close
              puts "#{path}が存在しなかったので、新規作成しました"
            end

            content = File.read path
            http_proxy = "Acquire::http::Proxy"
            https_proxy = "Acquire::https::Proxy"
            configs = [http_proxy, https_proxy]

            configs.each do |config|
              regex = /.*#{config}.*/
              match_data = content.scan(regex)
              
              if match_data.size == 0
                new_line = "#{config} #{_url};\n"
                content += new_line
                puts "追加しました｡: #{new_line}"
                next
              end
              
              if match_data.size > 0
                p match_data
                printf "既に#{config}が存在します 書き換えますか(y/n)?"
                
                if read_line != "y"
                  puts "書き換えませんでした｡"
                  exit()
                end
                
                content = content.gsub(regex, "#{config} #{_url};")
                puts "書き換えました｡"
              end
            end
            
          else
            puts "このコマンドは対応していません (>_<)"
            exit()
          end

          File.write(path, content)

          puts "プロキシ設定が完了しました｡ (^_^)"
        end
      end
    end
  end

  MyCli.start ARGV
end
