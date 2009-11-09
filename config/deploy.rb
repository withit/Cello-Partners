set :application, "cello-partners"
set :repository,  "git@github.com:withit/Cello-Partners.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, '192.168.8.10'
role :app, "192.168.8.10"                          # This may be the same as your `Web` server
role :db,  "192.168.8.10", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

set :deploy_to, "/Library/WebServer/#{application}"

set :mongrel_cmd, '/usr/bin/mongrel_rails_persist'
set :mongrel_ports, 3000..3002
set :user, 'admin'
set :group, 'admin'

namespace :deploy do
  task :start, :roles => :app  do
    mongrel_ports.each do |port|
      sudo "#{mongrel_command} start -p #{port} -e production \
        --user #{user} --group #{group}"
    end
  end
  task :stop, :roles => :app  do
    mongrel_ports.each do |port|
      sudo "#{mongrel_cmd} stop -p #{port}"
    end
  end
  task :restart, :roles => :app do
    stop
    start
  end
end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
