module Switch::Proxy::Commands
    def execute(opts, args, io) 
        system args.join " "
    end
end

