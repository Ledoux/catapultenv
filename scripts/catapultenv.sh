if [ "$1" = "link-lib" ] ; then
  rm -rf node_modules && mkdir node_modules && \
  ln -sf $VIRTUAL_ENV/lib/node_modules/* ./node_modules && \
  rm -rf yarn.lock && yarn
fi

if [ "$1" = "reset-data" ] ; then
  mongo $2 --eval "db.$3.drop()" && \
  mongoimport --jsonArray --db $2 --collection $3 --file $VIRTUAL_ENV/data/json_data/$2/$3.json
fi

if [ "$1" = "fetch-data" ] ; then
  mongo $2 --eval "JSON.stringify(db.$3.find().toArray())"
fi

if [ "$1" = "serve-data" ] ; then
  ttab "mongod --dbpath $VIRTUAL_ENV/data/mongodb_data"
fi
