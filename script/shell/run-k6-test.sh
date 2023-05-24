#!/bin/sh

if [ ! -f ../envs/.env ] ; then
  export $(cat ./envs/.env | grep SERVICE_HOST | xargs)
  export $(cat ./envs/.env | grep SERVICE_PORT | xargs)
  export $(cat ./envs/.env | grep NODE_ENV     | xargs)

  date=$(date '+%Y_%m_%d_%H_%M_%S')
  docker run --net=host --rm -v "${PWD}:/local" --user $UID  -i grafana/k6 run /local/script/javascript/k6.js \
          --out json=/local/k6/report_$date.json \
          -e SERVICE_HOST=$SERVICE_HOST \
          -e SERVICE_PORT=$SERVICE_PORT \
          -e NODE_ENV=$NODE_ENV
  
  unset SERVICE_HOST
  unset SERVICE_PORT
  unset NODE_ENV

else
  echo -e "\033[1;31m"
  echo -e "Error: envs/.env file is not exsit\n"
  echo -e "\033[0m"
fi
