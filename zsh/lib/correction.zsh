if [[ "$ENABLE_CORRECTION" == "true" ]]; then
    alias heroku='nocorrect heroku'
    alias man='nocorrect man'
    alias mkdir='nocorrect mkdir'
    alias mv='nocorrect mv'
    alias sudo='nocorrect sudo'

    setopt correct_all
fi
