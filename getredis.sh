#!/bin/bash

output_file="redis_get_ssl_settings_report.csv"
echo "SubscriptionID,RedisName,ResourceGroup,enableNonSslPort,minimumTlsVersion" > "$output_file"

echo "Fetching list of Azure subscriptions..."
subscriptions=$(az account list --query '[].id' -o tsv)

for sub in $subscriptions; do
  sub_clean=$(echo "$sub" | tr -d '\r')

  redis_list=$(az redis list --subscription "$sub_clean" --query "[].{name:name,rg:resourceGroup}" -o tsv 2>/dev/null)

  [[ -z "$redis_list" ]] && continue

  while IFS=$'\t' read -r name rg; do
    enable_non_ssl=$(az redis show --name "$name" --resource-group "$rg" --subscription "$sub_clean" --query "enableNonSslPort" -o tsv)
    tls_version=$(az redis show --name "$name" --resource-group "$rg" --subscription "$sub_clean" --query "minimumTlsVersion" -o tsv)

    echo "$sub_clean,$name,$rg,$enable_non_ssl,$tls_version" >> "$output_file"
  done <<< "$redis_list"
done

echo "CSV report saved to $output_file"
