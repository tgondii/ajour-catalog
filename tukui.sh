#!/usr/bin/env bash
if [ $# -eq 0 ]
  then
    echo "Usage: tukui output_file"
    exit 1
fi
tukui_endpoint="https://www.tukui.org/api.php?addons=all"
data=$(curl -s $tukui_endpoint)
echo "$data" | jq -c 'map({"id": .id | tonumber, "name": .name, "summary": .small_desc | gsub("[\\r\\n\\t]"; ""), "numberOfDownloads": .downloads | tonumber, "categories": [.category], "source": "tukui" })' > $1
