#NYCDevShop Server Deploy Guide


###create droplet
* Log in to [Digital Ocean](http://digitalocean.com)
* Enter hostname
* Select 1gb / 1cpu Droplet
* Use Ubuntu 12.0.4
* Do not use ssh keys
* Sign in information will be emailed to Alec after droplet is provisioned.

###ssh in as root
* Open Terminal
* ssh into the new server as root: `ssh root@128.199.248.35` (your ip will be different)
* type yes to the RSA Key Fingerprint prompt.
* enter password from the DO email.


###add the wheel group:


  /usr/sbin/groupadd wheel

  

###edit visudo permissions file:

  

  * run /usr/sbin/visudo
  * this will open the sudors.tmp file which must be accessed via root.
  



###add wheel group permissions to the visudo file:



  ## Allows people in group wheel to run all commands

  %wheel  ALL=(ALL)       ALL
  
  write out with control o
  exit with control x
  


###add a sudo user:

  

  /usr/sbin/adduser railsapps
  
  give railsapps a password 
  
  enter default information for user



###add the sudo user to the wheel group



  /usr/sbin/usermod -a -G wheel railsapps

  

###update the aptitude package manager



  sudo aptitude update

  

###upgrade the aptitude package manger



  sudo aptitude safe-upgrade
  select Y to continue



9) install build-essential



  sudo aptitude install build-essential



10) exit and shh back in as railsapps

ssh railsapps@107.170.7.171

11) create a download directory



  a) mkdir ~/downloads

  b) cd ~/downloads

  

12) download ruby 1.9.3 to the downloads directory



  sudo wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz

  sudo wget ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz

13) get all the dependencies you could ever need

sudo apt-get update

  sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison nodejs subversion



14) untar the ruby download



  tar xvfz ruby-1.9.3-p0.tar.gz
  tar xvfz ruby-2.1.0.tar.gz



15) move into the ruby install directory and configure

do this as root!

  a) cd ruby-1.9.3-p0

  b) ./configure

  c) make

  d) sudo make install

big step - go get a coffee. 217.4 seconds


16) update all gems


? sudo apt-get install rubygems - this installs ruby 1.8 don't use!
  sudo gem update --system  gem command not found if ruby not built as root
disregard debian errors


17) install rails



  sudo gem install rails

go get some more coffee.  

check ruby -v
rails -v for right version numbers.


18) install apache

  

  sudo aptitude install apache2



19) install mysql



  sudo aptitude install mysql-server mysql-client libmysqlclient15-dev
  assign a password for mysql - should be the name of the database?  something you don't mind having in public.



20) install passenger



  sudo gem install passenger



21) install passenger apache module



  sudo passenger-install-apache2-module

instructions from passenger - to edit appache file




22) update missing dependencies



  a) sudo aptitude install apache2-prefork-dev - conflicts with threaded-dev

  b) 



23) re-try the passenger apache module install



  sudo passenger-install-apache2-module



24) add the output from the mod rails installation to the apache configuration file, save and restart



  a) sudo nano /etc/apache2/apache2.conf

  b) sudo /etc/init.d/apache2 restart



25) make ssh directory

su railsapps

  a) mkdir ~/.ssh

  b) cd ~/.ssh



26) generate an ssh key



  ssh-keygen -t rsa -C "nichol@nycdevshop.com"
default file location /home/railsapps/.ssh/id_rsa
no passphrase


27) read in the file



  cat id_rsa.pub



28) then paste this key into the deploy keys section of the repo in github

key name - "server"
entire entry - incl. ssh-rsa

29) create a vhost file to tell apache where to serve the application

*directory does not yet exits.

  sudo nano /etc/apache2/sites-available/APPNAME
  sudo nano /etc/apache2/sites-available/innercircle



30) paste in the configuration



   <VirtualHost *:80>



     ServerName  domain1.com

     ServerAlias www.domain1.com


WRONG ROUTE - souldn't have current/public in it.

     DocumentRoot /home/railsapps/public_html/APPNAME/current/public



   </VirtualHost>



31) enable mod rewrite



  sudo a2enmod rewrite
  
  following instruction to run service apache2 restart



32) enable the vhost config file for the project



  sudo a2ensite APPNAME
  sudo a2ensite innercircle

following instruction to run service apache2 reload

warning documentRoot does not exist

33) restart apache



  sudo /etc/init.d/apache2 restart



34) add a mysql database for your project



  mysql -u root -p

  

  *the password is the password that you set when you set up mysql*



35) create the database and a user:



  a) create database APPNAME;

  b) grant all privileges on *.* to 'railsapps'@'localhost' identified by 'PASSWORD';

  c) flush privileges;

  d) exit

substitute password 123

36) change the deploy settings in the application and in the database.yml file



37) deploy setup

http://guides.beanstalkapp.com/deployments/deploy-with-capistrano.html

cap production deploy

  cap deploy:setup
  
  
  notes:
  
  If you would like to change the MySQL root password, in a terminal enter:

sudo dpkg-reconfigure mysql-server-5.5


reinstall
aptitude purge ruby
git force


/etc/apache2/sites-available

http://askubuntu.com/questions/256013/could-not-reliably-determine-the-servers-fully-qualified-domain-name


added cap-bundler
and cap -rails


LoadModule passenger_module /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.37/buildout/apache2/mod_passenger.so
   <IfModule mod_passenger.c>
     PassengerRoot /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.37
     PassengerDefaultRuby /usr/local/bin/ruby
   </IfModule>
   

Suppose you have a web application in /somewhere. Add a virtual host to your
Apache configuration file and set its DocumentRoot to /somewhere/public:

   <VirtualHost *:80>
      ServerName www.yourhost.com
      # !!! Be sure to point DocumentRoot to 'public'!
      DocumentRoot /somewhere/public    
      <Directory /somewhere/public>
         # This relaxes Apache security settings.
         AllowOverride all
         # MultiViews must be turned off.
         Options -MultiViews
      </Directory>
   </VirtualHost>
   
   why no rvm?
   dif between apt-get and aptitude
   
   
   CAPISTRANO 
   
   set stage production in capfile
   
   what diagnostics are there for passenger
   
   set deploy to appname not with current /public
   
   
   