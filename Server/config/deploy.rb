set :application, "coffeeme"
set :repository,  "git@github.com:anerian/coffeeme.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"
set :tmpdir_remote, "/var/www/apps/#{application}/tmp/"
set :tmpdir_local, File.join(File.dirname(__FILE__),'..','tmp')

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :use_pty, true
set :use_sudo, false
default_run_options[:pty] = true

role :app, "rack1"
role :web, "rack1"
role :db,  "rack1", :primary => true

set :port, 222
set :user, 'deployer'
set :password, 'deployer-deployer'
set :keep_releases, 5
after "deploy:update", "deploy:cleanup"

# define custom start/stop
namespace :rails do
  task :start, :roles => :web do
    run "cd #{current_path}/Server && #{try_runner} nohup script/spin start"
    #run "#{sudo} /usr/bin/monit -g vcc -c /etc/monit.conf monitor all", :pty => true
  end

  desc "restart the rails process"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}/Server && #{try_runner} nohup script/spin restart"
  end

  desc "stop the rails process"
  task :stop, :roles => :web do
    run "cd #{current_path}/Server && #{try_runner} nohup script/spin stop"
  end
end

namespace :deploy do
  desc "start rails and uploader processes"
  task :start, :roles => :web do
    rails.start
  end

  desc "stop rails and uploader processes"
  task :stop, :roles => :web do
    rails.stop
  end

  desc "restart the rails and uploader processes"
  task :restart, :roles => :app, :except => { :no_release => true } do
    rails.restart
  end
end