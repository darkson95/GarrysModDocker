FROM ubuntu:latest
MAINTAINER darkson95

#Ubuntu requirements
RUN apt-get update && apt-get -y install lib32gcc1 git wget lib32tinfo5 lib32stdc++6 unzip dos2unix curl nano

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
VOLUME ["/steamdir"]

#Server Start
WORKDIR /root
ADD start.sh /root/start.sh
RUN dos2unix /root/start.sh
RUN chmod 755 /root/start.sh

CMD ["/bin/sh", "/root/start.sh"]
