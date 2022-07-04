const path = require('path');

module.exports = {
  /** @type {import('pm2').Proc} */
  apps: [
    {
      instances: 'max',
      exec_mode: 'cluster',
      cwd: path.join(__dirname, '.'),
      name: 'next-pm2-example',
      script: './node_modules/next/dist/bin/next',
      args: `start ${path.join(__dirname)}`,
      // node_args: ['--require', './insights.js'],
      exec_interpreter: 'node',
    },
  ],
};
