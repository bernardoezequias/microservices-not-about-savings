#!/bin/bash

output_dir=""
deployments=("")

fetch_metrics() {
  local deployment=$1
  local timestamp=$(date +%Y%m%d%H%M%S) 
  local output_file="${output_dir}/${deployment}_metrics_${timestamp}.json"
  
  echo "Consultando métricas para o deployment: $deployment"
  
  response=$(curl -s "http://localhost:9090/api/v1/query?query=kube_deployment_spec_replicas")
  
  if [ $? -eq 0 ]; then
    echo "Resposta do curl: $response"
    
    echo "$response" > "$output_file"
    
    if [ -s "$output_file" ]; then
      echo "Dados salvos em: $output_file"
    else
      echo "Erro: O arquivo $output_file está vazio ou não foi criado."
    fi
  else
    echo "Erro ao executar curl para o deployment: $deployment"
  fi
}

mkdir -p "$output_dir"

for deployment in "${deployments[@]}"; do
  fetch_metrics "$deployment"
done

