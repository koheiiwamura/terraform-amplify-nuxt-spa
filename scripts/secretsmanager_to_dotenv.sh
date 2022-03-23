#!/bin/bash -e
SECRET_ID="$1"

aws secretsmanager get-secret-value \
  --secret-id "${SECRET_ID}" \
  --query SecretString \
| jq -r 'fromjson | keys[] as $k | "\($k)=\"\(.[$k])\""' > .env
