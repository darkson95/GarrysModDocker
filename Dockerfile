FROM ubuntu:latest
MAINTAINER darkson95

###############################################################################################################

#Ubuntu requirements
RUN apt-get update && apt-get -y install lib32gcc1 wget lib32tinfo5 lib32stdc++6 unzip dos2unix

# Set the locale
RUN locale-gen de_DE.UTF-8  
ENV LANG de_DE.UTF-8  
ENV LANGUAGE de_DE:de  
ENV LC_ALL de_DE.UTF-8
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Server config
EXPOSE 27015/tcp
EXPOSE 27015/udp

# Adding non-root user
RUN echo "root:alpine" | chpasswd
RUN adduser --disabled-password --gecos '' user
USER user

###############################################################################################################

#Steamcmd installation
RUN mkdir -p /home/user/steamcmd
WORKDIR /home/user/steamcmd
RUN wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN ./steamcmd.sh +login anonymous +app_update 4020 validate +app_update 232330 validate +quit
RUN cp /home/user/steamcmd/linux32/libstdc++.so.6 /home/user/Steam/steamapps/common/GarrysModDS/bin/

#Add GarrysModConfigs
WORKDIR /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg
RUN rm network.cfg
RUN rm mount.cfg
RUN rm server.cfg
ADD mount.cfg /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/mount.cfg
ADD server.cfg /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
RUN touch network.cfg
USER root
RUN dos2unix /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/mount.cfg
RUN dos2unix /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
RUN chown user.user /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/mount.cfg
RUN chown user.user /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/cfg/server.cfg
USER user

#Add ULX
RUN mkdir /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/addons/ulx
WORKDIR /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/addons/ulx
RUN wget http://ulyssesmod.net/archive/ulx/ulx-v3_71.zip
RUN unzip ulx-v3_71.zip
RUN rm ulx-v3_71.zip

#Add ULib
RUN mkdir /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/addons/ulib
WORKDIR /home/user/Steam/steamapps/common/GarrysModDS/garrysmod/addons/ulib
RUN wget http://ulyssesmod.net/archive/ULib/ulib-v2_61.zip
RUN unzip ulib-v2_61.zip
RUN rm ulib-v2_61.zip

#Server Start
WORKDIR /home/user
RUN touch /home/user/start.sh
ADD start.sh /home/user/start.sh
USER root
RUN dos2unix /home/user/start.sh
RUN chmod 755 /home/user/start.sh
RUN chown user.user /home/user/start.sh
USER user

CMD ["/bin/sh", "/home/user/start.sh"]

###############################################################################################################
