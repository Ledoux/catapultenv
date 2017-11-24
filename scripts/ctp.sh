if [ "$1" = "install" ] || [ "$1" = "-i" ] ; then
  if [ "$2" = "node" ] || [ "$2" = "-n" ]; then
    if [ "$3" = "all" ] || [ "$3" = "-a" ]; then
      for module_dir in $MODULE_DIRS
      do
        cd $GIT_DIR/$module_dir && echo "\nctp -i -n in $module_dir" && ctp -i -n;
      done
      echo "ctp -i -n in all the $APP_DIRS"
      for app_dir in $APP_DIRS
      do
        cd $GIT_DIR/$app_dir && echo "\nctp -i -n in $app_dir" && ctp -i -n;
      done
    fi
    ctp -l && rm -rf yarn.lock && yarn
    if [[ -d "backend/servers/express-webrouter" ]]; then
      cd backend/servers/express-webrouter && ctp -l && ctp -i
    fi
  fi
  if [ "$2" = "python" ] || [ "$2" = "-p" ]; then
    pip install -r requirements.txt
  fi
fi

if [ "$1" = "github" ] || [ "$1" = '-g' ] ; then
  find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;
fi

if [ "$1" = "kill" ] || [ "$1" = "-k" ] ; then
  kill -9 $(lsof -i TCP:$2 | grep LISTEN | awk '{print $2}')
fi

if [ "$1" = "link" ] || [ "$1" = "-l" ] ; then
  source $VIRTUAL_ENV/scripts/env.sh
  if [ "$2" = "replace" ] || [ "$2" = "-r" ]; then
    echo "Create (or just check) the $VIRTUAL_ENV/lib/node_modules"
    mkdir -p $VIRTUAL_ENV/lib/node_modules
    echo "Symlink inside all the $MODULE_DIRS"
    for module_dir in $MODULE_DIRS
    do
      module_name=$(cd $GIT_DIR/$module_dir && cat package.json | grep 'name":' | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]');
      cd $VIRTUAL_ENV/lib/node_modules && rm -rf $module_name && ln -sf $GIT_DIR/$module_dir $module_name;
    done
  fi
  if [ "$2" = "all" ] || [ "$2" = "-a" ]; then
    for module_dir in $MODULE_DIRS
    do
      cd $GIT_DIR/$module_dir && echo "\nctp -l in $module_dir" && ctp -l;
    done
    echo "ctp -l in all the $APP_DIRS"
    for app_dir in $APP_DIRS
    do
      cd $GIT_DIR/$app_dir && echo "\nctp -l in $app_dir" && ctp -l;
      if [[ -d "backend/servers/express-webrouter" ]]; then
        cd backend/servers/express-webrouter && ctp -l
      fi
    done
  fi
  rm -rf node_modules && mkdir node_modules && \
  ln -sf $VIRTUAL_ENV/lib/node_modules/* ./node_modules
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

if [ "$1" = "scrap" ] || [ "$1" = "-s" ] ; then
  wget -p --mirror --convert-links $2
fi

if [ "$1" = "watch" ] || [ "$1" = "-w" ] ; then
  source $VIRTUAL_ENV/scripts/env.sh
  CONCURRENTLY_CMD="$VIRTUAL_ENV/lib/node_modules/.bin/concurrently"
  for module_dir in $MODULE_DIRS
  do
    CONCURRENTLY_CMD=$CONCURRENTLY_CMD" \"cd $GIT_DIR/$module_dir && npm run compile && npm run dev-watch\"" ;
  done
  echo $CONCURRENTLY_CMD
  eval $CONCURRENTLY_CMD
fi

if [ "$1" = "mongo" ] || [ "$1" = "-m" ]; then
  if [ "$2" = "start" ] || [ "$2" = "-s" ]; then
    ctp -m -k && sleep 1 && mongod --dbpath $VIRTUAL_ENV/data/mongodb_data
  fi
  if [ "$2" = "reset" ] || [ "$2" = "-r" ]; then
    mongo $3 --eval "db.$4.drop()" && \
    mongoimport --jsonArray --db $3 --collection $4 --file $VIRTUAL_ENV/data/json_data/$3/$4.json
  fi
  if [ "$2" = "fetch" ] || [ "$2" = "-f" ]; then
    mongo $2 --eval "JSON.stringify(db.$3.find().toArray())"
  fi
  if [ "$2" = "kill" ] || [ "$2" = "-k" ]; then
    kill -2 `pgrep mongod`
  fi
fi

if [ "$1" = "docker" ]; then
  if [ "$2" = "clean" ]; then
    docker stop $(docker ps -a -q) && \
    docker ps -a | grep 'Exited\|Created' | cut -d ' ' -f 1 | xargs docker rm && \
    docker rmi $(docker images -f "dangling=true" -q)
  fi
  if [ "$2" = "ip" ]; then
    echo $(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
  fi
fi
