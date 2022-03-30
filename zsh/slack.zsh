
# set slack status
function status() {
    typeset TOKEN_LOCATION=~/.config/slack_status/slack_status_token
    typeset SLACK_STATUS_API_TOKEN="$(cat $TOKEN_LOCATION 2>/dev/null)"
    # SLACK_STATUS_SETUP_INSTRUCTIONS=
    if [[ -z "$SLACK_STATUS_API_TOKEN" ]]; then
        echo "
Please store a status token in $TOKEN_LOCATION.
The token should be from an app installed in your workspace that has
the following User Token OAuth scopes:
 - users.profile:read
 - users.profile:write
 - users:write
"
        return;
    fi

    case $1 in
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
            ;;
        "lunch" )
            typeset output=$(curl https://slack.com/api/users.profile.set \
                                  --silent \
                                  --request POST \
                                  --header "Content-Type: application/json; charset=utf-8" \
                                  --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
                                  --data '{"profile": {"status_text": "lunchtime", "status_emoji": ":chompy:"}}'
                    )
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
        "errand" )
            typeset output=$(curl https://slack.com/api/users.profile.set \
                                  --silent \
                                  --request POST \
                                  --header "Content-Type: application/json; charset=utf-8" \
                                  --header "Authorization: Bearer $SLACK_STATUS_API_TOKEN" \
                                  --data '{"profile": {"status_text": "errand", "status_emoji": ":car:"}}'
                    )
            ;;

        *)
            echo "please provide a valid command: clear/lunch/errand" ;;
    esac

    if [[ "$2" == '--debug' ]]; then
        echo $output
    fi
}
