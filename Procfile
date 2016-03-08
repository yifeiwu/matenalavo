#web: bundle exec rails server thin -p $PORT -e $RACK_ENV

web: bundle exec passenger start -p $PORT --max-pool-size 3
