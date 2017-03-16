source $VIRTUAL_ENV/scripts/env.sh

CONCURRENTLY_CMD="$VIRTUAL_ENV/lib/node_modules/.bin/concurrently"
for module_dir in $MODULE_DIRS
do
  CONCURRENTLY_CMD=$CONCURRENTLY_CMD" \"cd $GIT_DIR/$module_dir && npm run compile && npm run dev-watch\"" ;
done
echo $CONCURRENTLY_CMD
eval $CONCURRENTLY_CMD
