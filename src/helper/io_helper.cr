require "colorize"

module Switch::Proxy::Helper::IOHelper
    extend self

    def error(string) 
        "[ERROR]\t".colorize(:red).to_s + string
    end
    
    def info(string)
        "[INFO]\t" + string
    end

    def warn(string)
        "[WARN]\t".colorize(:yellow).to_s + string
    end

    macro pp_debug(string)
        puts "{{string}}: #{{{string}}.inspect}"
    end
end