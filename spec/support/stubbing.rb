RSpec.configure do |config|
  config.before(:each) do
    Shell.stubs(:exec)

    ::File.stubs(:exists?).with(USER_VIM_PATH).returns(true)
    ::File.stubs(:readable?).with(USER_VIM_PATH).returns(true)

    ::File.stubs(:exists?).with(USER_VIMRC_PATH).returns(true)
    ::File.stubs(:readable?).with(USER_VIMRC_PATH).returns(true)

    ::File.stubs(:exists?).with(USER_GVIMRC_PATH).returns(true)
    ::File.stubs(:readable?).with(USER_GVIMRC_PATH).returns(true)

    ::File.stubs(:exists?).with(MODULES_FILE).returns(true)
    ::File.stubs(:readable?).with(MODULES_FILE).returns(true)
    ::File.stubs(:writable?).with(MODULES_FILE).returns(true)

    ::File.stubs(:exists?).with(CONFIG_FILE).returns(true)
    ::File.stubs(:readable?).with(CONFIG_FILE).returns(true)
    ::File.stubs(:writable?).with(CONFIG_FILE).returns(true)

    TgConfig.any_instance.stubs(:parse_config_file).
      returns({"submodules" => ["pathogen", "tlib", "github"]}.with_indifferent_access)
    Vimius::Submodules.any_instance.stubs(:parse_config_file).
      returns(submodules.with_indifferent_access)

    @file_handler = mock "File Handler"
    @file_handler.stubs(:write)
    ::File.stubs(:open).with(MODULES_FILE, 'w').yields(@file_handler)
    ::File.stubs(:open).with(CONFIG_FILE, 'w').yields(@file_handler)

    ::FileUtils.stubs(:mv).with(USER_VIM_PATH, "#{USER_VIM_PATH}.old")
    ::FileUtils.stubs(:mv).with(USER_VIMRC_PATH, "#{USER_VIMRC_PATH}.old")
    ::FileUtils.stubs(:mv).with(USER_GVIMRC_PATH, "#{USER_GVIMRC_PATH}.old")
  end

  config.after(:each) do
    Vimius.config.send(:instance_variable_set, :@config, nil)
    Vimius.submodules.send(:instance_variable_set, :@config, nil)
  end
end

