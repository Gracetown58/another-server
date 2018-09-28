#!/bin/bash

export IPV4=$(cat ~/Documents/Projects/Sundog/ip)
export KEY=~/.ssh/root_tharsis002_digital_ocean
ssh -i $KEY root@$IPV4
