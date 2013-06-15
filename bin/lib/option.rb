module Option
  def self.add_option(options, opts, short_name, long_name, opt_name)
    opts.on(short_name, long_name) { options[opt_name] = true }
  end

  def self.add_option_with_param(options, opts, short_name, long_name, opt_name)
    opts.on(short_name, long_name) { |param| options[opt_name] = param }
  end

  def self.add_option_with_param_and_type(options, opts, short_name, long_name, opt_name, type)
    opts.on(short_name, long_name, type) { |param| options[opt_name] = param }
  end

  def self.add_option_single(options, opts, name, opt_name)
    opts.on(name) { options[opt_name] = true }
  end

  def self.add_option_with_param_single(options, opts, name, opt_name)
    opts.on(name) { |param| options[opt_name] = param }
  end

  def self.add_option_with_param_and_type_single(options, opts, name, opt_name, type)
    opts.on(name, type) { |param| options[opt_name] = param }
  end

  def self.add_option_block(options, opts, short_name, long_name, opt_name, &block)
    opts.on(short_name, long_name) { options[opt_name] = true; block.call }
  end

  def self.add_option_with_param_block(options, opts, short_name, long_name, opt_name, &block)
    opts.on(short_name, long_name) { |param| options[opt_name] = param; block.call }
  end

  def self.add_option_with_param_and_type_block(options, opts, short_name, long_name, opt_name, type, &block)
    opts.on(short_name, long_name, type) { |param| options[opt_name] = param; block.call }
  end

  def self.add_option_single_block(options, opts, name, opt_name, &block)
    opts.on(name) { options[opt_name] = true; block.call }
  end

  def self.add_option_with_param_single_block(options, opts, name, opt_name, &block)
    opts.on(name) { |param| options[opt_name] = param; block.call }
  end

  def self.add_option_with_param_and_type_single_block(options, opts, name, opt_name, type, &block)
    opts.on(name, type) { |param| options[opt_name] = param; block.call }
  end
end