set :stage, :development

server '192.168.140.73', user: 'deploy', roles: %w{web app db}