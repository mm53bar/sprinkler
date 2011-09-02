package :redis, :provides => :nosql do
  description 'Install redis'

  requires :redis_core
end

package :redis_core do
  requires :build_essential

  runner "mkdir -p /usr/local/redis && mkdir -p /usr/local/build && mkdir -p /usr/local/sources"
  runner "cd /usr/local/sources && wget http://redis.googlecode.com/files/redis-2.2.12.tar.gz"
  runner "cd /usr/local/build && tar xzf /usr/local/sources/redis-2.2.12.tar.gz"
  runner "cd /usr/local/build/redis-2.2.12 && make PREFIX=/usr/local/redis"
  runner "mkdir -p /usr/local/redis/bin"
  runner "cp /usr/local/build/redis-2.2.12/src/redis-{cli,server,benchmark,check-aof,check-dump} /usr/local/redis/bin"
  
  verify do
    has_directory "/usr/local/redis"
  end
end