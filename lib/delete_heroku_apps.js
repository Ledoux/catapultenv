const childProcess = require('child_process')

const apps = childProcess.execSync('heroku apps')
                         .toString('utf-8')
                         .split('Apps')[1]
                         .split('\n')
                         .filter(text => text.trim() !== '')
                         .slice(0, -1)
apps.forEach(app => {
  const command = `heroku apps:destroy ${app} --confirm ${app}`
  console.log(command)
  console.log(childProcess.execSync(command).toString('utf-8'))
})
