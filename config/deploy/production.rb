set :deploy_to, "/var/www/virtualhosts/beta.jacobjoins.com/"
set :rails_env, "staging"
set :branch, ENV["BRANCH"] || "master"