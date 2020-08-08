require "../../helper/file_helper"

module Switch::Proxy::Commands::Internal
  include Switch::Proxy::Helper::FileHelper

  def cp_json(opts, args, io)
    src = Path["./.swpro.json"].normalize.expand(home: true)
    dest = Path["~/.swpro.json"].normalize.expand(home: true)
    cp src: src, dest: dest, io: io
  end
end
