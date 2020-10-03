#!/bin/sh -l

index=0
page_size=5
number_of_addons=0
curse_endpoint="https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&pageSize=${page_size}"
addons="a lot of addons"

while [ $number_of_addons -le $page_size ]
do
  data=$(curl -s curse_endpoint)

  # number_of_addons = data.length
  # concat addons.

  sleep 1
  index=$(( $index + $page_size ))
done

echo "::set-output name=addons::$addons"
