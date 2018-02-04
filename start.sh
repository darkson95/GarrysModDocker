#!/bin/bash

if [ ! -d /steamdir/steamcmd ]; then
    mkdir /steamdir/steamcmd
    mkdir /steamdir/gmod
    mkdir /steamdir/css
    
    cd /steamdir/steamcmd
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
    ./steamcmd.sh \
        +login anonymous \
        +force_install_dir ../gmod \
        +app_update 4020 validate \
        +force_install_dir ../css \
        +app_update 232330 validate \
        +quit
    
    cd /steamdir/gmod/garrysmod/addons
    git clone https://github.com/TeamUlysses/ulib.git
    git clone https://github.com/TeamUlysses/ulx.git
fi

cd /steamdir/gmod/garrysmod/addons/ulib
git pull
cd /steamdir/gmod/garrysmod/addons/ulx
git pull

/steamdir/steamcmd/steamcmd.sh \
    +login anonymous \
    +force_install_dir ../gmod \
    +app_update 4020 validate \
    +force_install_dir ../css \
    +app_update 232330 validate \
    +quit
/steamdir/gmod/srcds_run \
    -steamcmd_script /steamdir/steamcmd/steamcmd.sh \
    -steam_dir /steamdir/steamcmd \
    -console \
    -maxplayers $MAXPLAYERS \
    -game garrysmod \
    -authkey $AUTHKEY \
    +gamemode terrortown \
    +map $MAP \
    +host_workshop_collection $WORKSHOP \
    +sv_setsteamaccount $STEAM
