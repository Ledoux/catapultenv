GIT_DIR=$VIRTUAL_ENV/../..
mkdir -p $VIRTUAL_ENV/lib/node_modules
for module_dir in Ledoux/entitiex Ledoux/filtex Ledoux/transactionx-client Ledoux/transactionx-express
do
  rm -rf $GIT_DIR/$module_dir/node_modules ; \
  cd $VIRTUAL_ENV/lib/node_modules && ln -sf $GIT_DIR/$module_dir . ; \
  cd $GIT_DIR/$module_dir && ctp -i -n
done
for app_dir in ClimateFeedback/fact-check-conpute ClimateFeedback/fact-check-conpute/backend/servers/express-webrouter
do
  cd $GIT_DIR/$app_dir && ctp -i -n;
done
