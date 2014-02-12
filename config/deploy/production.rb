set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{innercircle.nycdevshop.com}
role :web, %w{innercircle.nycdevshop.com}
role :db,  %w{innercircle.nycdevshop.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
# server 'innercircle.nycdevshop.com', user: 'railsapps', roles: %w{web app} #, my_property: :my_value

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
 # set :ssh_options, {
 #   auth_methods: %w(password)
 # }
# and/or per server
server 'innercircle.nycdevshop.com',
  user: 'railsapps',
  roles: %w{web app},
  ssh_options: {
    user: 'railsapps', # overrides user setting above
    keys: %w(/home/railsapps/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(password),
    password: 'Poiuytrewq1'
  }
# setting per server overrides global ssh_options
