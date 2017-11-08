# frozen_string_literal: true

require 'redis-namespace'

class ViewingChannel < ApplicationCable::Channel
  module ViewingMemory
    REDISNS = Redis::Namespace.new('ViewingChannel', redis: $redis)

    def self.add base_key, view, user
      REDISNS.sadd 'all_views', view
      REDISNS.rpush key(base_key, view), user
    end

    def self.get_views base_key
      view_hash = {}

      for_all_views do |view|
        view_hash[view] = REDISNS.lrange(key(base_key, view), 0, -1)
      end

      view_hash
    end

    def self.remove(base_key, view, user)
      # # if the user has no more connection, remove all remaining occurrences (0)
      # # in case a disconection got missed
      # if REDIS.pubsub('numsub', base_key).last.zero?
      #   remove_all base_key, user
      # else
      REDISNS.lrem key(base_key, view), 1, user
      # end
    end

    # def self.remove_all base_key, user
    #   for_all_views do |view|
    #     REDISNS.lrem key(base_key, view), 0, user
    #   end
    # end

    at_exit do # clean up in case of a server abort / restart
      REDISNS.keys.each { |key| REDISNS.del(key) }
    end

    private_class_method

    def self.key(base_key, view)
      "#{base_key}:#{view}"
    end

    def self.for_all_views(&block)
      REDISNS.smembers('all_views').each(&block)
    end
  end

  def subscribed
    stream_from channel_name(params)
    add_view_and_broadcast(params)
  end

  def unsubscribed
    stop_all_streams
    ViewingMemory.remove(channel_name(params), params['view'], user)
    broadcast(params)
  end

  def change_view(data)
    previous_channel = channel_name(data['last'])
    next_channel = channel_name(data['next'])

    ViewingMemory.remove(previous_channel, data['last']['view'], user)

    if previous_channel != next_channel
      stream_from next_channel
      broadcast(data['last'])
    end

    add_view_and_broadcast(data['next'])
  end

  private

  def add_view_and_broadcast hash
    ViewingMemory.add(channel_name(hash), hash['view'], user)
    broadcast(hash)
  end

  def broadcast hash
    channel = channel_name(hash)
    channel_hash = ViewingMemory.get_views(channel)
    ActionCable.server.broadcast(
      channel, model: hash['model'], id: hash['id'], views: channel_hash
    )
  end

  def channel_name hash
    ['viewing', hash['model'], hash['id']].join(':')
  end

  def user
    current_user.id
  end
end
