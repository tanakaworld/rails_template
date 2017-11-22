# -*- coding: utf-8 -*-

@app_name = app_name
@repo_url = 'https://raw.githubusercontent.com/tanakaworld/rails-template/master'

gem 'rails', '~> 5.1.4'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.7'
gem 'puma_worker_killer'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails', '3.1.1'
gem 'compass-rails', github: 'Compass/compass-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem "uikit-sass-rails", git: 'https://github.com/8398a7/uikit-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
gem "figaro" # app configuration in config/application.yml
gem 'config' # Multi-environment configuration
gem 'devise'
gem 'acts_as_list'
gem 'rails_autolink'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'enum_help'
gem "paranoia", "~> 2.2"
gem 'amoeba'
gem 'pundit'
gem 'fastimage'
gem 'cocoon'
gem 'number_to_yen'
gem 'fastimage'
gem 'autonumeric-rails'
gem 'aws-sdk', '~>2'
gem 'aws-ses', '~> 0.6'
gem 'meta-tags', require: 'meta_tags'
gem 'ckeditor'
gem 'mini_magick'
gem 'carrierwave'
gem 'fog'
gem 'rmagick'
gem 'remotipart'

gem_group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end


gem_group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'binding_of_caller'
  gem 'seed_dump'
  gem 'better_errors'
  gem 'bullet'

  # deploy
  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-figaro', require: false
end

gem_group :test do
  gem 'rspec-rails'
  gem 'capybara', '~>2.15.1'
  # gem 'capybara-webkit',  '~>1.1.0'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Uglifier doesn't load with Ruby 2.4.0 using The Ruby Racer JS runtime.
# https://stackoverflow.com/questions/41461977/after-ruby-2-4-upgrade-error-while-trying-to-load-the-gem-uglifier-bundler
gem 'therubyracer', git: 'https://github.com/cowboyd/therubyracer.git'


# rspec initalize setting
run 'bundle install --path=vendor/bundle'
run 'rm -rf test'
generate 'rspec:install'

# rm unused files
run "rm README.rdoc"


# database
run 'rm config/database.yml'

database_yml_sample = <<-FILE
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: 123456
  host: localhost
development:
  <<: *default
  database: #{@app_name}
test:
  <<: *default
  database: #{@app_name}_test
FILE

File.open("config/database.yml.sample", "w") do |file|
  file.puts database_yml_sample
end

# run 'bundle exec rake db:create'

# set config/application.rb
application do
  %q{
    config.time_zone = 'Tokyo'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:ja, :en]

    config.autoload_paths += Dir[
        "#{config.root}/app/models/**/",
        "#{config.root}/app/validators/**/",
        "#{config.root}/app/serializers/**/",
        "#{config.root}/lib/**/"
    ]

    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      if html_tag =~ /<(input|label|textarea|select)/
        html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
        html_field.children.add_class 'has-error'
        "<span class='has-error'>#{html_field.to_s}</span>".html_safe
      else
        html_tag
      end
    end

    config.enable_dependency_loading = true
  }
end

# set config/development.rb
development do
  %q{
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = {host: ENV['THEO_MONEY_DIAGNOSIS_HOST'], port: 3000}

    # Rails generators
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.jbuilder false
      g.template_engine :slim
      g.stylesheet_engine = :sass
      g.test_framework :rspec,
                       fixture: true,
                       fixture_replacement: :factory_girl,
                       view_specs: false,
                       controller_specs: false,
                       routing_specs: false,
                       helper_specs: false,
                       integration_tool: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # bullet
    config.after_initialize do
      Bullet.enable = true
      Bullet.raise = true
      Bullet.alert = true # JS alert in browser
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.rails_logger = true
    end
  }
end

# figaro
run "bundle exec figaro install"

# config
run "bundle exec rails g config:install"

# application.yml.sample
File.open("config/application.yml.sample", "w") do |file|
  file.puts <<-APPLICATIOON_YML_SAMPLE
    RAILS_ENV: development
    #{@app_name.upcase}_HOST: localhost
    #{@app_name.upcase}_PRODUCTION_IP: 'xxx.xxx.xxx.xxx'
    #{@app_name.upcase}_PRODUCTION_SSH_KEY: 'xxx.xxx.xxx.xxx'
  APPLICATIOON_YML_SAMPLE
end

# i18(ja)
run "rm config/locales/ja.yml"
run "wget #{@repo_url}/config/locales/ja.yml -p config/locales/ja.yml"
run "wget #{@repo_url}/config/locales/devise.ja.yml -p config/locales/devise.ja.yml"
run "wget #{@repo_url}/config/locales/devise.en.yml -p config/locales/devise.en.yml"

# assets
run "rm app/assets/stylesheets/application.css"
run "rm app/assets/javascripts/application.js"
run 'mkdir -p app/assets/stylesheets/core/'
run "wget #{@repo_url}/app/assets/stylesheets/core/_base.sass -p app/assets/stylesheets/core/_base.sass"
run "wget #{@repo_url}/app/assets/stylesheets/core/_mixin.sass -p app/assets/stylesheets/core/_mixin.sass"
run "wget #{@repo_url}/app/assets/stylesheets/core/_variable.sass -p app/assets/stylesheets/core/_variable.sass"
run "wget #{@repo_url}/app/assets/stylesheets/core/_base.sass -p app/assets/stylesheets/core/_base.sass"
File.open("app/assets/stylesheets/application.sass", "w") do |file|
  file.puts <<-SASS
    /*
     *= require_self
     */
    
    // Base
    @import compass
    @import core/_normalize
    @import core/_mixin
    @import core/_variable
    @import core/_base
  SASS
end
File.open("app/assets/javascripts/application.js", "w") do |file|
  file.puts <<-JS
    //= require jquery
    //= require jquery.turbolinks
    //= require jquery_ujs
    //= require cocoon
    //= require turbolinks
    //= require_tree .
  JS
end

# puma
File.open("config/puma.rb", "w") do |file|
  file.puts <<-PUMA
    def development?
      ENV.fetch("RAILS_ENV") == "development"
    end
    
    workers(ENV.fetch("WEB_CONCURRENCY") {2}.to_i) unless development?

    threads_count = ENV.fetch("RAILS_MAX_THREADS") {5}.to_i
    threads threads_count, threads_count

    preload_app! unless development?
    
    rackup DefaultRackup
    
    port ENV.fetch("PORT") {3000}
    
    environment ENV.fetch("RAILS_ENV") {"development"}

    on_worker_boot do
      ActiveRecord::Base.establish_connection unless development?
    end
    
    before_fork do
      require 'puma_worker_killer'
      PumaWorkerKiller.enable_rolling_restart(4 * 3600) #every 4 hours
    end
    
    # Allow puma to be restarted by `rails restart` command.
    plugin :tmp_restart
  PUMA
end

# capistrano
run "bundle exec cap install"
# puma
File.open("config/deploy.rb", "w") do |file|
  file.puts <<-CAP
    # config valid for current version and patch releases of Capistrano
    lock "~> 3.10.0"
    
    server ENV['THEO_MONEY_DIAGNOSIS_PRODUCTION_IP'], port: 22, roles: [:app, :web, :db], primary: true
    set :application, "#{@app_name}"
    set :repo_url, ""
    set :user, 'deploy'
    set :ssh_options, {
        forward_agent: true,
        user: fetch(:user),
        keys: ["#{ENV['#{@app_name.upcase}_PRODUCTION_SSH_KEY']}"]
    }
    set :keep_releases, 5
    set :puma_threads, [4, 16]
    set :puma_workers, 2
    set :pty, true
    set :use_sudo, false
    set :stage, :production
    set :deploy_via, :remote_cache
    set :deploy_to, "/var/www/#{fetch(:application)}"
    set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
    set :puma_state, "#{shared_path}/tmp/pids/puma.state"
    set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
    set :puma_access_log, "#{release_path}/log/puma.access.log"
    set :puma_error_log, "#{release_path}/log/puma.error.log"
    set :puma_preload_app, true
    set :puma_worker_timeout, nil
    set :puma_init_active_record, true
    set :rbenv_type, :system
    set :rbenv_ruby, '2.4.2'
    set :rbenv_path, '/home/ubuntu/.rbenv'
    set :linked_dirs, fetch(:linked_dirs, []).push(
        'log',
        'tmp/pids',
        'tmp/cache',
        'tmp/sockets',
        'vendor/bundle',
        'public/system',
        'public/uploads'
    )
    set :linked_files, fetch(:linked_files, []).push(
        'config/application.yml',
        'config/database.yml',
        'config/secrets.yml'
    )
    
    namespace :puma do
      desc 'Create Directories for Puma Pids and Socket'
      task :make_dirs do
        on roles(:app) do
          execute "mkdir #{shared_path}/tmp/sockets -p"
          execute "mkdir #{shared_path}/tmp/pids -p"
        end
      end
      before :start, :make_dirs
    end
    
    namespace :deploy do
      desc "Make sure local git is in sync with remote."
      task :check_revision do
        on roles(:app) do
          unless `git rev-parse HEAD` == `git rev-parse origin/master`
            puts "WARNING: HEAD is not the same as origin/master"
            puts "Run `git push` to sync changes."
            exit
          end
        end
      end
    
      desc 'Initial Deploy'
      task :initial do
        on roles(:app) do
          before 'deploy:restart', 'puma:start'
          invoke 'deploy'
        end
      end
    
      desc 'Restart application'
      task :restart do
        on roles(:app), in: :sequence, wait: 5 do
          invoke 'puma:restart'
        end
      end
    
      before :starting, :check_revision
      after :finishing, :compile_assets
      after :finishing, :cleanup
    end
  CAP
end


# git initialize setting
after_bundle do
  git :init
  git add: '.'
  git commit: %Q{ -m 'Initialize commit' }
end
