role :app, "paco.captive.fr"
role :web, "paco.captive.fr"
role :db,  "paco.captive.fr", :primary => true


default_run_options[:pty] = true
set :application, "paco"
set :repository,  "git@github.com:captivestudio/paco.git"
set :scm, 'git'
set :branch, "master"


# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

# load 'ext/rails-database-migrations.rb'
# load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/paco/rails"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
# see a full list by running "gem contents capistrano | grep 'scm/'"

set :user, "paco"
set :password, "paco"
set :use_sudo, false
set :admin_runner, "paco"

before "deploy:update" do
  run "rake gems:install"
end

after 'deploy:finalize_update' do
  run "cd #{release_path} && ln -s #{shared_path}/db/production.sqlite3 db/"
end

namespace :deploy do
  desc "Restart Application"
  task :restart do
   run "touch  #{current_path}/tmp/restart.txt"
  end

  desc "Start Application -- not needed for Passenger"
  task :start do 
     # nothing - just override
   end
end

task :before_restart do
end