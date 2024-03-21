Sidekiq.configure_server do |config|
        config.redis = { url: ENV['REDIS_URL'] || 'rediss://:p13b358b93004473881473253a8077b80fa73c446dbaf6446318427450e5d277b@ec2-54-227-144-219.compute-1.amazonaws.com:12150' , ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }}
end

Sidekiq.configure_client do |config|
        config.redis = { url: ENV['REDIS_URL'] || 'rediss://:p13b358b93004473881473253a8077b80fa73c446dbaf6446318427450e5d277b@ec2-54-227-144-219.compute-1.amazonaws.com:12150' , ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }}
end