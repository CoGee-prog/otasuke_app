# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "otasuke_app"
set :deploy_to, '/var/www/otasuke_app'

set :repo_url, "git@github.com:CoGee-prog/otasuke_app.git"

append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"



set :keep_releases, 3

set :rbenv_type, :user
set :rbenv_ruby, '2.6.7'

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/.unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }


after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end