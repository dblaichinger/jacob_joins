namespace :assets do
  desc "Copy assets from [SOURCE] to local machine (replaces system folder). SOURCE is staging by default."
  task :copy do
    if ENV["SOURCE"] == "production"
      sh "scp -r cpf_deploy@jacobjoins.com:/var/www/virtualhosts/jacobjoins.com/shared/system/ ./public"
    else
      sh "scp -r cpf_deploy@jacobjoins.com:/var/www/virtualhosts/beta.jacobjoins.com/shared/system/ ./public"
    end
  end
end