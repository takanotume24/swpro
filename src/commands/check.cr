def check(opts, args, io)
  check_arg_num opts, args, num = 0
  configs = read_json SWPRO_CONF_PATH, io
  configs = configs.nil? ? return -1 : configs
  is_vaild_json? configs, io
end
