source 'http://rubygems.org'

group :development, :test do
  # Rspec
  gem 'rspec'
  gem 'mocha'

  # Pry
  gem 'pry'

  # Guard
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'

  platforms :ruby do
    # Require rbconfig to figure out the target OS
    require 'rbconfig'

    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', require: false
        gem 'ruby-growl', require: false
        gem 'growl', require: false
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', require: false
        gem 'libnotify', require: false
      end
    end
  end
end
