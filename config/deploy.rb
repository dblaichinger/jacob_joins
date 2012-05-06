set :rvm_ruby_string, "1.9.3"
set :rvm_type, :system
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"

set :stages, %w(staging production)
require "capistrano/ext/multistage"

set :application, "jacob_joins"

set :scm, :git
set :repository,  "git@github.com:dblaichinger/jacob_joins.git"
set :deploy_via, :remote_cache
default_run_options[:pty] = true

set :user, "cpf_deploy"
set :use_sudo, false

role :web, "jacobjoins.com"
role :app, "jacobjoins.com"
role :db,  "jacobjoins.com", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :copy_config do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{latest_release}/config/mongoid.yml"
    run "ln -nfs #{shared_path}/config/mailers.yml #{latest_release}/config/mailers.yml"
    run "ln -nfs #{shared_path}/config/secret_token.rb #{latest_release}/config/initializers/secret_token.rb"
  end
end

require "bundler/capistrano"

before "deploy:assets:precompile", "deploy:copy_config"