#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "Usage: curse output_file"
    exit 1
fi

index=0
page_size=500
number_of_addons=$page_size
endpoint="https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&pageSize=${page_size}"
tmp=$(mktemp -d -t ci-XXXXXXXXXX)
new=$tmp/new.json
running=$tmp/running.json
all=$tmp/addons.json
touch $running
while [ $number_of_addons == $page_size ]
do
  curse_endpoint="$endpoint&index=${index}"
  data=$(curl -s $curse_endpoint)
  number_of_addons=$(echo $data | jq '. | length')
  echo $data | jq \
    'map({
      "id": .id,
      "name": .name,
      "summary": .summary,
      "numberOfDownloads": .downloadCount,
      "categories": [.categories[] | .name],
      "flavors": [.gameVersionLatestFiles[] | .gameVersionFlavor] | unique,
      "source": "curse" })' > $new
  jq -s add $running $new > $all
  cat $all > $running
  index=$(( $index + $page_size ))
done

cat $all > $1
rm -rf $tmp
