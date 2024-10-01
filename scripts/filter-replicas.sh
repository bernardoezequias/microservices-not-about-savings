#!/bin/bash

json_dir=""
temp_file=""
changes_file=""

> "$temp_file"
> "$changes_file"

for file in "$json_dir"/*.json; do
  jq -r '.data.result[] | "\(.metric.deployment) \(.value[0]) \(.value[1])"' "$file" >> "$temp_file"
done

sort "$temp_file" | awk '
BEGIN {
  last_replicas[""] = "";  # Inicializa array associativo
}
{
  deployment = $1;
  timestamp = $2;
  replicas = $3;
  cmd = "date -d @" timestamp " +\"%Y-%m-%d %H:%M:%S\"";
  cmd | getline formatted_date;
  close(cmd);

  if (replicas != last_replicas[deployment] && last_replicas[deployment] != "") {
    print "Deployment: " deployment " - Date: " formatted_date " - Replicas: " replicas;
  }
  last_replicas[deployment] = replicas;
}' > "$changes_file"

echo "Mudanças no número de réplicas identificadas. Confira os timestamps em $changes_file."

