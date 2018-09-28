export IPV4=$(cat ~/Documents/Projects/Sundog/ip)
export KEY=~/.ssh/root_tharsis002_digital_ocean
export PROJECT=~/Documents/Projects/Pavonis
export GIT_SSH_COMMAND="ssh -i $KEY -q"

ssh -i $KEY root@$IPV4 'bash -s' < sundog-acme-data.sh
