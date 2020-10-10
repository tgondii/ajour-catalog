#!/usr/bin/env bash
if [ $# -eq 0 ]
  then
    echo "Usage: tukui output_file"
    exit 1
fi

endpoint="https://www.tukui.org/api.php"
retail_endpoint="$endpoint?addons=all"
classic_endpoint="$endpoint?classic-addons=all"
tmp=$(mktemp -d -t ci-XXXXXXXXXX)
retail=$tmp/retail.json
classic=$tmp/classic.json
all=$tmp/all.json
curl -s $retail_endpoint | jq '[.[] | . + { "flavors": ["wow_retail"] }]' > $retail
curl -s $classic_endpoint | jq '[.[] | . + { "flavors": ["wow_classic"] }]' > $classic
jq -s add $retail $classic > $all
if [ $(jq 'length' $all) -eq "0" ]; then
  echo "Error: Found 0 tukui addons"
  exit 1;
fi
jq -c \
  'map(
  {
    "id": .id|tonumber,
    "name": .name,
    "summary": .small_desc|gsub("[\\r\\n\\t]"; ""),
    "numberOfDownloads": .downloads|tonumber,
    "categories": (if (.category == null) then [] else [.category] end),
    "flavors": .flavors,
    "source": "tukui"
  })' $all > $1
rm -rf tmp
