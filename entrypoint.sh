#!/usr/bin/env bash

index=0
page_size=500
# Assumes that we have atleast 1 page
number_of_addons=$page_size
addons=[]

while [ $number_of_addons == $page_size ]
do
  curse_endpoint="https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&pageSize=${page_size}&index=${index}"
  data=$(curl -s $curse_endpoint)
  number_of_addons=$(echo "$data" | jq '. | length')
  echo $(echo "$data" | jq 'map({"id": .id, "name": .name, "summary": .summary, "numberOfDownloads": .downloadCount, "categories": [.categories[] | .name], "source": "curse" })') > new.json
  addons=$(echo $addons | jq --argfile n new.json '. + $n')

  index=$(( $index + $page_size ))
done

echo "::set-output name=addons::$addons"
