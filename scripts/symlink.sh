source $VIRTUAL_ENV/scripts/env.sh

echo "Create (or just check) the $VIRTUAL_ENV/lib/node_modules"
mkdir -p $VIRTUAL_ENV/lib/node_modules
echo "Symlink inside all the $MODULE_DIRS"
for module_dir in $MODULE_DIRS
do
  module_name=${module_dir##*/};
  cd $VIRTUAL_ENV/lib/node_modules && rm -rf $module_name && ln -sf $GIT_DIR/$module_dir .;
done
echo "rm yarn.lock, node_modules in all the $MODULE_DIRS"
for module_dir in $MODULE_DIRS
do
  rm -f $GIT_DIR/$module_dir/yarn.lock; \
  rm -rf $GIT_DIR/$module_dir/node_modules;
done
echo "ctp -i -n in all the $MODULE_DIRS"
for module_dir in $MODULE_DIRS
do
  cd $GIT_DIR/$module_dir && echo "\nctp -i -n in $module_dir" && ctp -i -n;
done
echo "ctp -i -n in all the $APP_DIRS"
for app_dir in $APP_DIRS
do
  cd $GIT_DIR/$app_dir && echo "\nctp -i -n in $app_dir" && ctp -i -n;
done
