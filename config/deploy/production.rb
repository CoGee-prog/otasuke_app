server '13.114.166.139', user: 'kosuke', roles: %w{app db web}

set :ssh_options, {
  keys: [ENV.fetch('PRODUCTION_SSH_KEY').to_s],
  forward_agent: true,
  auth_methods: %w[publickey]
}