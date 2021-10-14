server '13.114.166.139', user: 'kosuke', roles: %w{app db web}

set :ssh_options, {
  auth_methods: ['publickey'], 
  keys: ["#{ENV['PRODUCTION_SSH_KEY']}"],
	forward_agent: true
}