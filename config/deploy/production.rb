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