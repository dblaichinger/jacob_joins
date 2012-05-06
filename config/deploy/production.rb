set :deploy_to, "/var/www/virtualhosts/jacobjoins.com/"
set :rails_env, "production"
set :branch, ENV["BRANCH"] || "master"