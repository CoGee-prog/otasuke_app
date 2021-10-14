set :ssh_options, {
  auth_methods: ['publickey'], 
  keys: ["#{ENV['PRODUCTION_SSH_KEY']}"],
	forward_agent: true
}