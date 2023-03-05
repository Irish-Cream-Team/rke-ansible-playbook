kube_config_path=$1
key_vault_url=$2
vault_kube_name=$3
token=`curl -s -H "Metadata:true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net" | jq -r .access_token`

echo '{"value": "'$(base64  $kube_config_path | tr -d '\n')'"}' > payload.json

curl -s -X PUT -H "Authorization: Bearer $token" -H "Content-Type: application/json" --data @payload.json "$key_vault_url/secrets/$vault_kube_name?api-version=7.1"

rm payload.json
