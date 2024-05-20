FROM ubuntu:22.04

LABEL name="Servidor de Redes" maintainer="ferragut@fi365.ort.edu.uy"

# Set up the systems
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo dnsutils iputils-ping iproute2 telnetd ftpd openssh-server lighttpd postfix dovecot-pop3d dovecot-imapd bind9 supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#Create users    
RUN useradd -m redes --shell /bin/bash \
    && echo redes:redes | chpasswd \
    && usermod -aG sudo redes

RUN useradd -m ort-grupo1 --shell /bin/bash \
    && echo ort-grupo1:ort-grupo1 | chpasswd

RUN useradd -m ort-grupo2 --shell /bin/bash \
    && echo ort-grupo2:ort-grupo2 | chpasswd

RUN useradd -m ort-grupo3 --shell /bin/bash \
    && echo ort-grupo3:ort-grupo3 | chpasswd

RUN useradd -m ort-grupo4 --shell /bin/bash \
    && echo ort-grupo4:ort-grupo4 | chpasswd

# Add alias netstat=ss for all users
RUN echo "alias netstat=ss" >> /etc/profile

WORKDIR /root

#HTTP
ADD confs/web_content /var/www/html

#SSH

#TELNET, FTP
COPY confs/inetd/inetd.conf /etc/inetd.conf

#Public files for FTP
RUN mkdir -p /home/publico
ADD confs/publico /home/publico

#POP3
COPY confs/dovecot/dovecot.conf /etc/dovecot/dovecot.conf

#SMTP
ADD confs/postfix/ /etc/postfix
#this script is needed to start postfix from supervisord
RUN chmod a+x /etc/postfix/postfix_init.sh

#DNS
ADD confs/bind9 /etc/bind

#SCRIPTS
ADD confs/scripts /root
RUN chmod a+x /root/enlace1.sh /root/enlace2.sh /root/liberar_enlace.sh
ADD confs/scripts /home/redes
RUN chmod a+x /home/redes/enlace1.sh /home/redes/enlace2.sh /home/redes/liberar_enlace.sh

#Supervisor daemon
RUN mkdir -p /var/run/sshd /var/run/dovecot /var/run/lighttpd /var/run/inetd /var/log/supervisor
COPY confs/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
