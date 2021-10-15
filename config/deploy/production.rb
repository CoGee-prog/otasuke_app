server '13.114.166.139', user: 'kosuke', roles: %w{app db web}

set :ssh_options, {
  keys: ["#{ENV['PRODUCTION_SSH_KEY']}"],
	forward_agent: true,
	auth_methods: ['publickey']
}