module Switch::Proxy::Hepler::SystemHelper
    include Switch::Proxy::Helper::IOHelper

    def get_user_name
        sudo_user = ENV["SUDO_USER"]?
        if sudo_user
            return sudo_user
        end

        return ENV["USER"]
    end

    def execute_after_execute(after_execute, io)
        after_execute.each do |command|
          io.puts exec command
          result =`#{command}`
          if $?.normal_exit? == false
            io.puts error "Faild execute #{command}"
            return nil
          end

          return $?
        end
    end
end