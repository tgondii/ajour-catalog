#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "Usage: curse output_file"
    exit 1
fi

index=0
page_size=500
number_of_addons=$page_size
addons=[]
while [ $number_of_addons == $page_size ]
do
  curse_endpoint="https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&pageSize=${page_size}&index=${index}"
  data=$(curl -s $curse_endpoint)
  number_of_addons=$(echo "$data" | jq '. | length')
  echo $(echo "$data" | jq 'map({"id": .id, "name": .name, "summary": .summary, "numberOfDownloads": .downloadCount, "categories": [.categories[] | .name], "flavors": [.gameVersionLatestFiles[] | .gameVersionFlavor] | unique, "source": "curse" })') > new.json
  addons=$(echo $addons | jq -r -c --argfile n new.json '. + $n')
  rm new.json
  index=$(( $index + $page_size ))
done

echo $addons > $1

