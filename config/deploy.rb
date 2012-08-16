#variables
set :user, 'webmin'
set :domain, '192.168.20.4'
set :application, 'web'

#path
set :repository, "https://github.com/looshme/web1-.git"
set :deploy_to, "/home/webmin/apps/web/current/public/"

#rvm
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#require "rvm/capistrano"
#set :rvm_ruby_string, '1.9.3'
#set :rvm_type, :user

#roles
role :app, domain
role :web, domain
role :db, domain,:primary => true

#defaults
default_run_options[:pty] = true

# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :rails_env, :production

namespace :deploy do
  
end
desc "cause Passenger to initiate a restart"
task :restart do
run "touch #{current_path}/tmp/restart.txt"
end

desc "reload the database with seed data"
task :seed do
run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
end 

after "deploy:update_code", :bundle_install 
desc "install the necessary prerequisites" 
task :bundle_install, :roles => :app do
run "cd #{release_path} && bundle install" 
end