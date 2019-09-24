web: pumactl start
redis: redis-server
worker: QUEUE=* rake resque:work
ticker: ruby tick.rb