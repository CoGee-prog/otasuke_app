server '13.114.166.139', user: 'kosuke', roles: %w{app db web}

set :ssh_options, {
  keys: ['~/.ssh/otasuke_app_rsa'],
	forward_agent: true,
	auth_methods: %w[publickey]
}