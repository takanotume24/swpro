# TODO: Write documentation for `Switch::Proxy`
require "clim"
module Switch::Proxy
  VERSION = "0.1.0"
  
  class MyCli < Clim
    @@data = 1
    
    main do
      desc "proxy setting tool."
      usage "swpro [sub_command] [arguments]"
      
      run do |opts, args|
        puts opts.help_string
      end
      
      sub "enable" do
        desc "enable proxy setting"
        usage "swpro enable [command] [proxy server uri]"
        
        run do |opts, args|
          puts "proxy enabled ^_^"
        end
      end
      
      sub "set" do
        desc "set configs"
        usage "swpro set [command] [proxy server uri]"
        
        run do |opts, args|
          if(args.none?) 
            puts opts.help_string
            exit()
          end
          
          path = args[0]
          if(!File.writable? path)
            puts "書き込みできません >_< 権限を確認してください。"
            exit()
          end
          
          if (!File.file? path)
            file = File.new(path, "w")
            file.close
          end
          puts "proxy set. ^_^"
        end
      end
      
    end
  end
  
  MyCli.start ARGV
end
