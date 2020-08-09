module Switch::Proxy::Hepler::SystemHelper
    def get_user_name
        sudo_user = ENV["SUDO_USER"]?
        if sudo_user
            return sudo_user
        end

        return ENV["USER"]
    end
end