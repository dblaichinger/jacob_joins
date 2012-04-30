$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.2"
set :rvm_type, :system

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
    run "ln -fs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
    run "ln -fs #{shared_path}/config/mailers.yml #{release_path}/config/mailers.yml"
    run "ln -fs #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
end

require "bundler/capistrano"

after "deploy:update_code", "deploy:copy_config"