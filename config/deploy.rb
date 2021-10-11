# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "otasuke_app"
set :deploy_to, '/var/www/rails/otasuke_app'

set :repo_url, "git@example.com:CoGee-prog/otasuke_app.git"

append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

set :ssh_options, {
  auth_methods: ['publickey'], 
  keys: ['~/.ssh/otasuke.pem'] 
}

set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, '2.6.7'
# set :rbenv_path, '/home/ec2-user/.rbenv'

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }


after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end