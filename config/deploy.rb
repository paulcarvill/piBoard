require 'bundler/capistrano'

set :scm,             :git
set :repository,      "git@github.com:paulcarvill/piBoard.git"
set :branch,          "origin/master"

set :ssh_options,     { :forward_agent => true }
set :rails_env,       "production"
set :deploy_to,       "/home/deployer/apps/piBoard"

set :rack_env, :production
set :unicorn_conf, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :public_children, ["css","img","js"]

set :user,            "deployer"
set :group,           "staff"
server "192.168.0.8", :app, :web, :db, :primary => true

default_environment["RAILS_ENV"] = 'production'

# Use our ruby-1.9.2-p290@piBoard gemset
default_environment["PATH"]         = "/usr/local/rvm/gems/ruby-1.9.3-p429@piBoard/bin:/usr/local/rvm/gems/ruby-1.9.3-p429@global/bin:/usr/local/rvm/rubies/ruby-1.9.3-p429/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games"
default_environment["GEM_HOME"]     = "/usr/local/rvm/gems/ruby-1.9.3-p429@piBoard"
default_environment["GEM_PATH"]     = "/usr/local/rvm/gems/ruby-1.9.3-p429@piBoard:/usr/local/rvm/gems/ruby-1.9.3-p429@global"
default_environment["RUBY_VERSION"] = "ruby-1.9.3-p429"

default_run_options[:shell] = 'bash'
default_run_options[:pty] = true

namespace :deploy do

  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D; fi"
  end

  task :start do
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D"
  end

  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

end