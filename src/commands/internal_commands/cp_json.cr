def cp_json(opts, args, io)
  src = Path["./.swpro.json"].normalize.expand(home: true)
  dest = Path["~/.swpro.json"].normalize.expand(home: true)
  cp src: src, dest: dest, io: io
end
