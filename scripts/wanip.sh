#! /bin/bash

# Outputs the public ip of the host or "ERROR" if not available
valid_ip() {
  if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo true
  else
    echo false
  fi
}

# Try multiple ways to get our own public IP before giving up
declare -a arr=(
  "dig @resolver1.opendns.com A myip.opendns.com +short -4"
  "dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short -4"
  "curl -s http://icanhazip.com"
  "curl -s http://ifconfig.me"
  "curl -s http://whatismyip.akamai.com"
)

# Try each possible way 5 times stopping when one works
for com in "${arr[@]}"
do
  for i in {1..5}; do
    ip=$(bash -c "$com")
    valid=$(valid_ip $ip)
    $valid && break
    sleep 0.1
  done
  $valid && break
done

if $valid; then
  echo "$ip"
else
  echo "ERROR"
fi
