set :deploy_to, "/var/www/virtualhosts/jacobjoins.com/"
set :rails_env, "staging"
set :branch, ENV["BRANCH"] || "master"