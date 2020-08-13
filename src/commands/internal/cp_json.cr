require "../../helper/file_helper"

module Switch::Proxy::Commands::Internal
  extend self
  include Switch::Proxy::Helper::FileHelper

  def cp_json(opts, args, io)
    files = ["proxy_list.json", "user_config.json"]

    files.each do |file|
      process_path = Process.executable_path
      if process_path.nil?
        io.puts error "Cannot get Process.executable_path."
        return nil
      end

      process_path = Path[process_path]
      io.puts process_path
      src = Path[process_path.parent, "..","configs", file].normalize.expand(home: true)
      dest = Path["~/.swpro/#{file}"].normalize.expand(home: true)
      mkdir_p dest.parent

      cp src: src, dest: dest, io: io
    end
  end
end
