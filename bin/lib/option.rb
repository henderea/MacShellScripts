module Option
  def self.add_option(options, opts, short_name, long_name, opt_name)
    opts.on(short_name, long_name) { options[opt_name] = true }
  end

  def self.add_option_with_param(options, opts, short_name, long_name, opt_name)
    opts.on(short_name, long_name) { |name| options[opt_name] = name }
  end

  def self.add_option_with_param_and_type(options, opts, short_name, long_name, opt_name, type)
    opts.on(short_name, long_name, type) { |name| options[opt_name] = name }
  end
end