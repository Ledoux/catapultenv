# catapultenv

<table>
  <td>
    <img src="icon.png" alt="icon" title="made by @cecilesnips"/>
  </td>
  <td>
    Catapult your dependencies without going into the details.
  </td>
</table>

## Install catapultenv

1. Make sure you have these global dependencies

  ```
  sudo pip install virtualenv
  ```

  ```
  sudo npm install -g yarn ttab
  ```

2. Install your catapultenv setup, python and node (via nodeenv)
  ```
  cd catapultenv && virtualenv .
  ```

  ```
  source bin/activate && pip install nodeenv
  ```

  ```
  ttab "source bin/activate && nodeenv -p --node=6.9.1"
  ```

3. Install your libs
  ```
  cd lib && pip install -r requirements.txt && yarn
  ```

3. Create a binary command that will help you in your project to link to your catapultenv
  ```
   export VENV_APP=catapultenv && source bin/activate && touch $VENV_APP && echo "rm -rf node_modules && mkdir node_modules && ln -sf $VIRTUAL_ENV/lib/node_modules/* ./node_modules && rm -rf yarn.lock && yarn" >> $VENV_APP && chmod u+x $VENV_APP && mv $VENV_APP /usr/local/bin/$VENV_APP
  ```

## Install one project

Simply do
```
catapultenv
```
