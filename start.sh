#!/bin/bash

if ! grep -Fxq "sv_password" /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
then
	echo '' >> /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
	echo 'hostname '$TTTNAME >> /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
	echo 'sv_password '$TTTPW >> /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
fi

/home/user/steamcmd/steamcmd.sh +login anonymous +app_update 4020 validate +quit
/home/user/Steam/steamapps/common/GarrysModDS/srcds_run -steambin /home/user/steamcmd/steamcmd.sh -steam_dir /home/user/steamcmd -console -maxplayers $MAXPLAYERS -game garrysmod -authkey $AUTHKEY +gamemode terrortown +map $MAP +host_workshop_collection $WORKSHOP +sv_setsteamaccount $STEAM
