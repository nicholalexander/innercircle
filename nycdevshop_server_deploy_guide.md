![WD40](http://www.prrag.com/blog/wp-content/uploads/2006/09/wd40-p_logo_2color.gif =250x)

#The NYC DevShop 40 Step Server Deploy Guide
*Written by Nichol Alexander, Arun Umpathy, and Alec Hartman*

###1. Create A Droplet In A Digital Ocean

* Log in to [Digital Ocean](http://digitalocean.com)
* Enter hostname - this should be something useful to you, maybe your Appname?
* Select a 1gb / 1cpu Droplet
* Use Ubuntu 12.0.4
* Do not use ssh keys!
* Select a location close to you or your users.
* Sign in information will be emailed to you or the Digital Ocean account holder after droplet is provisioned.

###2. `ssh` in as root

* Open Terminal
* ssh into the new server as root: `ssh root@128.199.248.35` (your ip will be different - it will have been included in your email confirmation from Digital Ocean.)
* Type yes to the RSA Key Fingerprint prompt.
* Enter password (also in the Digital Ocean email)

###3. Add The Wheel Group

* `/usr/sbin/groupadd wheel`

###4. Edit `visudo` Permissions File

* Run `/usr/sbin/visudo`
* This will open the sudors.tmp file in [Nano](http://www.nano-editor.org/).  This must be accessed via root.

###5. Add wheel group permissions to the visudo file

* Enter `%wheel  ALL=(ALL)       ALL`
* Write out the file with control-o
* Exit the editor with control-x and type Y to save.
* This gives all users in the wheel group all nessecary permissions.

###6. Add A Sudo User
 
*  `/usr/sbin/adduser railsapps` OR THIS?  `sudo adduser railsapps sudo` 
* Give railsapps user a password at the prompt.
* Enter default information for user (return key).

###7. Add The Sudo User To The Wheel Group

* `/usr/sbin/usermod -a -G wheel railsapps`

###8. Update the Aptitude Package Manager

* `sudo aptitude update`

###9. Upgrade The Aptitude Package Manger

* `sudo aptitude safe-upgrade`
* select Y to continue.

###10. Install build-essential
* `sudo aptitude install build-essential`


###11. Return As railsapps

* exit from your SSH session.
* `ssh railsapps@107.170.7.171`
* The password is what you gave it earlier.

###12. Create A Download Directory

* This is where you are going to put Ruby!
* `mkdir ~/downloads`
* `cd ~/downloads`

###13. Download ruby To The Downloads Directory

* we want to be working with the last stable build of Ruby 2.0, so we find the source code link on [ruby-lang.org](ruby-lang.org)
* `sudo wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz`


###14. Get All The Dependencies You Could Ever Need

* `sudo apt-get update`
* `sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison nodejs subversion`

###15. Untar The Ruby Download

* `tar xvfz ruby-2.0.0-p353.tar.gz`

###16. Install Ruby!
(do this as root! - was this the problem with the make sudo user above?

* `cd ruby-1.9.3-p0`
* `./configure`
* `make`
* `sudo make install
* This'll take a while.  Watch and be amazed.  Go get a coffee.  Return and continue to be amazed.
* When it's done, check out `which ruby` and `ruby -v`.  You should see `usr/local/bin/ruby` and `ruby 2.0.0p353 (2013-11-22 revision 43784) [x86_64-linux]` respectively.

###17. Update All Gems

* `sudo gem update --system`
* If you get an error here telling you that the "gem command is not found", there was a problem with your installation of ruby.  DO NOT do a `sudo apt-get install rubygems` as you might find on StackOverflow - it will install ruby 1.8 and additional older dependencies which you don't want.  Instead, go back and trouble shoot your ruby installation.  Possibly you have a permissions problem with your railsapps user account...
* You may see some "debian errors" - disregard those.

###18. Install Rails
* `sudo gem install rails`
* Be amazed.  Go get some more coffee.  Return and continue to be amazed and the industry of your server.
* On completion, `rails -v` should yield `Rails 4.0.2`

###19. Install apache2
* sudo aptitude install apache2

###20. Install mysql
* `sudo aptitude install mysql-server mysql-client libmysqlclient15-dev`
* assign a password for mysql - should be the name of the database?  something you don't mind having in public.  *TODO: How can we hide the passwords from the database.yaml file?

###21. [I Am A Passenger](http://www.youtube.com/watch?v=S0nlygb1Qfw)

* sudo gem install passenger

###22. Install Passenger Apache Module

* `sudo passenger-install-apache2-module`
* Passenger is very friendly and tries to help you.  Follow the menu to install it for Ruby.  If it warns you on low memory, you may choose to reconfigure your settings, but we have not had a problem with running it despite the warning.  You will have some missing dependencies which Passenger would like to help you fix.

###23. Let Passenger Help You.

* copy and paste the instructions highlighted in yellow.  This will updated the threaded-dev and curl dependencies.


###24. Now Retry The Passenger
* `sudo passenger-install-apache2-module`
* You will see lots of friendly green followed by some instructions for modifying your virtual host and your LoadModule configuration.  You can hold off on the virtual host for now.  Here we do something a little different from Passenger's instructions.

###25. Add passenger.load
* Because we are using Apache2.2, which you can verify with `apache -v`, we are going to follow some best practices for installing the mods.  
* `cd /etc/apache2/mods-enabled`
* `nano passenger.load`
* Paste into the file `LoadModule passenger_module /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.37/buildout/apache2/mod_passenger.so`.  This is given to you from the successful conclusion of passenger-install-apache2-module but with some formatting around it.  Strip the formatting so that it is just that single line.
* Exit and save file.

###26. Add passenger.conf
* `nano passenger.conf`
* Paste into the file the following:
					
		PassengerRoot /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.37
		PassengerDefaultRuby /usr/local/bin/ruby
* These are also given by the successful completion of the passenger-install-apache2-module.  You can confirm that they are pointing to the correct locations by checking the directories for the presence of the linked referenced files.
* This is the conclusion of the Passenger configuration - you DO NOT NEED to put anything into the `apache2.conf` file.

###27. Restart Apache

* sudo /etc/init.d/apache2 restart



###28. Set Up ssh

* We're going to set up some ssh keys to help Capistrano manage the deployment off of Github.  First we need a directory.
* `su railsapps`
* `mkdir ~/.ssh`
* `cd ~/.ssh`

###29. Generate An ssh Key

* `ssh-keygen -t rsa -C "nichol@nycdevshop.com"` - but substitute your email address, of course!
* accept the default file location of `/home/railsapps/.ssh/id_rsa`
* no passphrase


###30. Read In The File

* `cat id_rsa.pub`
* Copy and paste the entire key starting before `ssh-rsa` until all the way after the email address.

###31. Set Your Deploy Keys On Github

* Goto the Settings page of your repo on Github.
* On the left hand side you will see `Deploy Keys`
* Click `Add Deploy Key`
* Give your key a name, "server" will do.
* Paste in your entire key.
* Click `Add Key`

###32 Create a vhost File
* `cd /etc/apache2/sites-available/`
* `nano APPNAME`, where APPNAME is the name of your application.

###33 Setup The Configuration

* You will need to replace the ServerName with the appropriate servername as identified by your DNS setup.

		<VirtualHost *:80>
			
			ServerName innercircle.nycdevshop.com 
			ServerAlias www.innercircle.nycdevshop.com
			
			# !!! Be sure to point DocumentRoot to 'public'!
			DocumentRoot /home/railsapps/public_html/APPNAME/current/public
			
			<Directory />
				Options -Indexes  
			</Directory>
			
		</VirtualHost>

* The `<Directory /> Options -Indexes </Directory>` prevents against an internal server error.  Don't ask me why.

###34. Enable Mod Rewrite

* `sudo a2enmod rewrite`
* follow instructions to run `service apache2 restart`

###35. Enable Vhost

* sudo a2ensite APPNAME
* sudo a2ensite innercircle
* follow instruction to run `service apache2 reload`

###36. Restart apache

* sudo /etc/init.d/apache2 restart

###37. Login To mysql

* `mysql -u root -p`
* The password is the password that you set when you set up mysql.


###38. Create Database And User

* `create database APPNAME;` where APPNAME is YOUR appname.
* `grant all privileges on *.* to 'railsapps'@'localhost' identified by 'PASSWORD';`, where PASSWORD is your password.
* `flush privileges;`
* `exit`
* Dont forget your semicolons!

###39. Change Your Deploy Settings
* Add 

		gem 'capistrano'
		gem 'capistrano-bundler'
		gem 'capistrano-rails'
* bundle install
* cap install (not Capify cause you is 3.0ing this Capistrano!)
* set your config/deploy/production.rb file to be:

		set :stage, :production
		
		role :app, %w{innercircle.nycdevshop.com}
		role :web, %w{innercircle.nycdevshop.com}
		role :db,  %w{innercircle.nycdevshop.com}

		server 'innercircle.nycdevshop.com',
			user: 'railsapps',
			roles: %w{web app},
			ssh_options: {
				user: 'railsapps', # overrides user setting above
				keys: %w(/home/railsapps/.ssh/id_rsa),
				forward_agent: false,
				auth_methods: %w(password),
				password: '123'
			}

* You will, of course, have to substitute as nessecary for your roles, username, and the password that you used for your railsapps account.
* Now lets setup `config/deploy.rb`.

		lock '3.1.0'

		set :application, 'innercircle'
		set :repo_url, 'https://github.com/thedevshop/InnerCircle.git'
		set :branch, 'master'
		
		set :deploy_to, '/home/railsapps/public_html/innercircle/current/public'

		SSHKit.config.command_map[:rake]  = "bundle exec rake" 
		SSHKit.config.command_map[:rails] = "bundle exec rails"
		
		namespace :deploy do
			desc 'Restart application'
			task :restart do
				on roles(:app), in: :sequence, wait: 5 do
					execute :touch, release_path.join('tmp/restart.txt')
				end
			end
			
			after :publishing, :restart
			
			after :restart, :clear_cache do
				on roles(:web), in: :groups, limit: 3, wait: 10 do
					# Here we can do anything such as:
					# within release_path do
					#   execute :rake, 'cache:clear'
					# end
				end
			end
		end

* Awesome!  Now, don't forget your database.yml file!

		production:
			adapter: mysql
			database: innercircle
			username: railsapps
			password: 123
* Sweet!

###40. Deploy!

* And now the moment you've been waiting for, good luck!
* `git add . `
* `git push origin branch`
* Merge your branch on github.
* Pull down your new master.
* Cross your fingers.
* `cap production deploy`

###Misc.  

* If you would like to change the MySQL root password, in a terminal enter: `sudo dpkg-reconfigure mysql-server-5.5`
* To get rid of an old version of Ruby - `aptitude purge ruby`
* To force a commit to overwrite master - `git force`
* [To resolve a warning on the apache server restarts](http://askubuntu.com/questions/256013/could-not-reliably-determine-the-servers-fully-qualified-domain-name)
* our passenger errors came from the wrong path - we set deploy to appname with /current/public
* properly guard passwords by putting them in .yml file, exclude from git, manually upload.
* Run cap production deploy:migrate to migrate db
* run bundle exec rake db:seed RAILS_ENV=production to seed the production db on your server (not on localhost)
