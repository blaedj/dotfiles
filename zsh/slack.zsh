
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
    # the -m or --message flag sets the "status_text" when provided. It
    # overwrites the default "status_text" used when one of the out-of-the-box
    # combos are applied

    positional_args=()
    # shift

    message=""
    while [[ "$#" -gt 0 ]]; do
      case "$1" in
        -m)
          shift
          message="$1"
          shift
          ;;
        --message=*)
          message="${1#*=}"
          shift
          ;;
        --message)
          shift
          message="$1"
          shift
          ;;
        -*)
          echo "Unknown option: $1"
          exit 1
          ;;
        *)
          positional_args+=("$1")
          shift
          ;;
      esac
    done

    cmd=$positional_args[@]
    for SLACK_STATUS_API_TOKEN in $SLACK_STATUS_API_TOKENS; do
      case $cmd in
        "clear")
          set_default_message ""
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data "{\"profile\": {\"status_text\": \"$message\", \"status_emoji\": \"\"}}"
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
          set_default_message "lunchtime"
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data "{\"profile\": {\"status_text\": \"$message\", \"status_emoji\": \":chompy:\"}}"
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
          set_default_message "afk"
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data "{\"profile\": {\"status_text\": \"$message\", \"status_emoji\": \":away:\"}}"
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
          set_default_message "on a call"

          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data "{\"profile\": {\"status_text\": \"$message\", \"status_emoji\": \":phone:\"}}"
                  )
          ;;

        "busy" )
          set_default_message "heads down"

          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data "{\"profile\": {\"status_text\": \"$message\", \"status_emoji\": \":cowboycoding:\"}}"
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
          set_default_message "errand"
          [[ -z "$message" ]] && message=$default_message
          typeset output=$(curl https://slack.com/api/users.profile.set \
            --silent \
            --request POST \
            --header "Content-Type: application/json; charset=utf-8" \
            --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
            --data "{\"profile\": {\"status_text\": \"$message\", \"status_emoji\": \":car:\"}}"
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

# used to set the default message for each command. If a message has already
# been defined via the -m/--message flag, does NOT override that
set_default_message() {
  [[ -z "$message" ]] && message="$1"
}
