module Switch::Proxy::Commands
    extend self
    
    def execute(opts, args, io) 
        system args.argv.join " "
    end
end

