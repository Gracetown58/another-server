# Sundog

Bash scripts for provisioning Ubuntu and an Nginx web server on a Digital Ocean
droplet.  See [Someone Else's Server](http://tharsis.io/Someone_Elses_Server.html)
for a rationale.

## Requirements

The scripts require a Digial Ocean account, authorisation and the [doctl](https://www.digitalocean.com/community/tutorials/how-to-use-doctl-the-official-digitalocean-command-line-client)
command line client.  See the linked documentation for details.

## `sundog-up`

`sundog-up.sh` is used to provision the server.  To create a new machine modify
the following two lines.  (The key file will be created by the script).  

    export HOST=tharsis001
    export KEY=~/.ssh/root_tharsis001_digital_ocean

Web server content is pushed to the server from another local git repository.  
Edit the folowing line in `sundog-up`

    export PROJECT=~/Documents/Projects/Pavonis

## `sundog-userdata.sh`

Server configuration is contained in `sundog-userdata.sh`, (which is run on the
remote machine by [cloud-init](https://cloud-init.io) ).  Don't run this script
locally.

## `sundog-push.sh`

To amend the content of the web server, alter the content in the project
repository, and run `sundog-push.sh`.  (This uses the key created by
`sundog-up.sh`)

## `sundog-login.sh`

The login script uses the ssh key created by sundog-up.  However, the server
should not be reconfigured manually.  To properly reconfigure the server, the
`sundog-userdata.sh` script should be modified, and a new server created.
