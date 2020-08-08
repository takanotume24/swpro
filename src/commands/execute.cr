module Switch::Proxy::Commands
    def execute(opts, args, io) 
        system args.argv.join " "
    end
end

