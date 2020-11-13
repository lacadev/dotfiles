#! /bin/bash

# Needs SENDGRID_API_KEY to be specified in secrets.sh

usage() {
	echo "Required flags: --to --from --subject --message"
}


while [[ "$#" -gt 0 ]]; do
    case $1 in
        --to) to="$2"; shift ;;
        --from) from="$2"; shift ;;
        --subject) subject="$2"; shift ;;
        --message) message="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; usage; exit 1 ;;
    esac
    shift
done


generate_post_data() {
  cat <<EOF
{
  "personalizations": [
    {
      "to": [
        {
          "email": "$to"
        }
      ],
      "subject": "$subject"
    }
  ],
  "from": {
    "email": "$from"
  },
  "content": [
    {
      "type": "text/plain",
      "value": "$message"
    }
  ]
}
EOF
}


SCRIPTS_DIR="/opt/scripts"
source "${SCRIPTS_DIR}/secrets.sh"


curl -X "POST" "https://api.sendgrid.com/v3/mail/send" \
	-H "Authorization: Bearer $SENDGRID_API_KEY" \
	-H "Content-Type: application/json" \
	-d "$(generate_post_data)"
