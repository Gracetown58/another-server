#!/bin/bash

export IPV4=$(cat ~/Documents/Projects/Sundog/ip)
export KEY=~/.ssh/root_tharsis001_digital_ocean
ssh -i $KEY root@$IPV4
