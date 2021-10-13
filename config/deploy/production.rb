server '13.114.166.139', user: 'kosuke', roles: %w{app db web}

set :ssh_options, {
  auth_methods: ['publickey'], 
  keys: ['~/.ssh/otasuke_key_rsa'],
	forward_agent: true
}