
# set slack status
function status() {
    typeset TOKEN_LOCATION=~/.config/slack_status/slack_status_token
    typeset SLACK_STATUS_API_TOKENS="$(cat $TOKEN_LOCATION 2>/dev/null)"
    # SLACK_STATUS_SETUP_INSTRUCTIONS=
    if [[ -z "$SLACK_STATUS_API_TOKENS" ]]; then
        echo "
Please store status tokens in $TOKEN_LOCATION, with a token for each
workspace on it's own line
Each token should be from an app installed in your workspace that has
the following User Token OAuth scopes:
 - users.profile:read
 - users.profile:write
 - users:write
 - dnd:write
"
        return;
    fi

    message=$1

    for SLACK_STATUS_API_TOKEN in $SLACK_STATUS_API_TOKENS; do
      case $message in
        "clear")
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"profile": {"status_text": "", "status_emoji": ""}}'
                  )
          typeset output2=$(curl https://slack.com/api/users.setPresence \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"presence": "auto"}'
                  )
          output="${output}\n${output2}"

          typeset output3=$(curl https://slack.com/api/dnd.endSnooze \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
                  )

          output="${output}\n${output3}"
          ;;
        "lunch" )
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"profile": {"status_text": "lunchtime", "status_emoji": ":chompy:"}}'
                  )

          typeset output2=$(curl https://slack.com/api/users.setPresence \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"presence": "away"}'
                  )
          output="${output}\n${output2}"

          typeset output3=$(curl https://slack.com/api/dnd.setSnooze \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"num_minutes": "90"}'
                  )
          output="${output}\n${output3}"
          ;;
        "away" )
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"profile": {"status_text": "afk", "status_emoji": ":away:"}}'
                  )

          typeset output2=$(curl https://slack.com/api/users.setPresence \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"presence": "away"}'
                  )
          output="${output}\n${output2}"
          ;;
        "call" )
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"profile": {"status_text": "on a call", "status_emoji": ":phone:"}}'
                  )
          ;;

        "busy" )
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"profile": {"status_text": "heads down", "status_emoji": ":cowboycoding:"}}'
                  )

          typeset output2=$(curl https://slack.com/api/dnd.setSnooze \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"num_minutes": "60"}'
                  )
          output="${output}\n${output2}"
          ;;
        "errand" )
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"profile": {"status_text": "errand", "status_emoji": ":car:"}}'
                  )
          typeset output2=$(curl https://slack.com/api/users.setPresence \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data '{"presence": "away"}'
                  )
          output="${output}\n${output2}"
          ;;

        *)
          echo "please provide a valid command: clear/lunch/away/call/errand/busy or use the -m flag to specify a custom message" ;;
      esac
    done

    if [[ "$2" == '--debug' ]]; then
        echo $output
    fi
}
