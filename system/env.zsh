# Only set this if we haven't set $EDITOR up somewhere else previously.
if [[ "$EDITOR" == "" ]] ; then
  # Use emacsclient for my editor.
  export EDITOR='e'
fi
