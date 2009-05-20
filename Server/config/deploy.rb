set :application, "coffeeme"
set :repository,  "git@github.com:anerian/coffeeme.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "rack1"
role :web, "rack1"
role :db,  "rack1", :primary => true
