require "../../helper/file_helper"

module Switch::Proxy::Commands::Internal
  extend self
  include Switch::Proxy::Helper::FileHelper

  def cp_json(opts, args, io)
    files = ["proxy_list.json", "user_config.json"]

    files.each do |file|
      src = Path["./configs/#{file}"].normalize.expand(home: true)
      dest = Path["~/.swpro/#{file}"].normalize.expand(home: true)
      mkdir_p dest.parent

      cp src: src, dest: dest, io: io
    end
  end
end
