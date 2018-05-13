#!/bin/bash

export IPV4=$(cat ~/Documents/Projects/Sundog/ip)
export KEY=~/.ssh/root_tharsis_digital_ocean
export PROJECT=~/Documents/Projects/Pavonis
export GIT_SSH_COMMAND="ssh -i $KEY -q"
cd $PROJECT
git remote set-url origin root@$IPV4:/srv/git/tharsis.git
git push origin master
ssh -i $KEY root@$IPV4 "cd /srv/www; git pull"
