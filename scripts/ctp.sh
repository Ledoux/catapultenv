if [ "$1" = "install" ] || [ "$1" = "-i" ] ; then
  if [ "$2" = "node" ] || [ "$2" = "-n" ]; then
    rm -rf node_modules && mkdir node_modules && \
    ln -sf $VIRTUAL_ENV/lib/node_modules/* ./node_modules && \
    rm -rf yarn.lock && yarn
  fi
  if [ "$2" = "python" ] || [ "$2" = "-p" ]; then
    pip install -r requirements.txt
  fi
fi

if [ "$1" = "link" ] || [ "$1" = "-l" ] ; then
  sh $VIRTUAL_ENV/scripts/symlink.sh
fi

if [ "$1" = "serve" ] || [ "$1" = "-s" ] ; then
  if [ "$2" = "data" ] || [ "$2" = "-d" ]; then
    mongod --dbpath $VIRTUAL_ENV/data/mongodb_data
  fi
fi

if [ "$1" = "deploy" ] || [ "$1" = "-d" ] ; then
  if [ "$2" = "install" ] || [ "$2" = "-i" ] ; then
    if [ $(echo $(ls scripts) | grep manage) == "manage.py" ] ; then
      git init && heroku create --buildpack heroku/python
    fi
    if [ $(echo $(ls scripts) | grep manage) == "manage.js" ] ; then
      git init && heroku create --buildpack heroku/node
    fi
  fi
  if [ "$2" = "push" ] || [ "$2" = "-p" ] ; then
    git add . && \
    git commit -m "$3" && \
    git push heroku master
  fi
  if [ "$2" = "status" ] || [ "$2" = "-s" ] ; then
    heroku apps:info
  fi
  if [ "$2" = "destroy" ] || [ "$2" = "-d" ] ; then
    if [ "$3" = "all" ] ; then
      node $VIRTUAL_ENV/lib/delete_heroku_apps.js
    else
      heroku apps:destroy --app $(heroku info | awk '$1 == "===" {print $3}')
    fi
  fi
fi

if [ "$1" = "registry" ] || [ "$1" = "-r" ] ; then
  if [ "$2" = "public" ] || [ "$2" = "-p" ] ; then
    npm set registry https://registry.npmjs.org
  fi
fi

if [ "$1" = "data" ]; then
  if [ "$2" = "reset" ] || [ "$2" = "-r" ]; then
    mongo $3 --eval "db.$4.drop()" && \
    mongoimport --jsonArray --db $3 --collection $4 --file $VIRTUAL_ENV/data/json_data/$3/$4.json
  fi
  if [ "$2" = "fetch" ] || [ "$2" = "-f" ]; then
    mongo $2 --eval "JSON.stringify(db.$3.find().toArray())"
  fi
fi
