#!/bin/bash
export HOME=/home/node
export PM2_HOME=$HOME/.pm2

# Start your Node.js application
pm2-runtime start /app/DDCS/ecosystem.config.js
