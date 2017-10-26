require "fakeredis"
require "sidekiq"

redis_opts = {:url => "redis://127.0.0.1:6379/1", :namespace => "cms_queue"}
# If fakeredis is loaded, use it explicitly
redis_opts.merge!(:driver => Redis::Connection::Memory) if defined?(Redis::Connection::Memory)

Sidekiq.configure_server do |config|
  config.redis = redis_opts
  schedule_file = "config/worker_schedule.yml"

  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end
