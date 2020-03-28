def check(opts, args, io)
  check_arg_num opts, args, num = 0
  configs = read_json SWPRO_CONF_PATH, io

  if configs.nil?
    abort
  end
  is_vaild_json? configs, io
end
