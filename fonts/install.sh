#!/bin/sh


if [ "$(uname -s)" = "Darwin" ]
then
    unzip Share_Tech_Mono.zip -d ./temp/
    mv ./temp/*.ttf ~/Library/Fonts/
    rm -r ./temp
    mv ./Inconsolata/*.ttf ~/Library/Fonts
    mv ./Source_Code_Pro/*.ttf ~/Library/Fonts
fi

if [ "$(uname -s)" = "Linux" ]
then
    unzip Share_Tech_Mono.zip -d ./temp/
    sudo mv ./temp/*.ttf /usr/share/fonts/truetype
    rm -r ./temp

    mkdir -p ~/.fonts
    unzip fontawesome.zip -d ./temp/
    mv ./temp/fontawesome-free-5.15.2-desktop/otfs/*.otf ~/.fonts/
    rm -r ./temp

    sudo cp ./Inconsolata/*.ttf /usr/share/fonts/truetype
    sudo cp ./Source_Code_Pro/*.ttf /usr/share/fonts/truetype

    # refresh the font cache
    fc-cache -f
fi
