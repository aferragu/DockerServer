FROM ubuntu:22.04

LABEL name="Servidor de Redes" maintainer="ferragut@fi365.ort.edu.uy"

# Set up the systems
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends iproute2 telnetd ftpd openssh-server lighttpd postfix dovecot-pop3d dovecot-imapd bind9 supervisor \
    && apt-get clean
    
RUN useradd -m redes \
    && echo redes:redes | chpasswd \
    && usermod -aG sudo redes

WORKDIR /root

#HTTP
ADD confs/web_content /var/www/html
EXPOSE 80

#SSH
EXPOSE 22 

#TELNET, FTP
COPY confs/inetd/inetd.conf /etc/inetd.conf
EXPOSE 23 20 21 30000:40000

#Public files for FTP
RUN mkdir -p /home/publico
ADD confs/publico /home/publico

#POP3
COPY confs/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
EXPOSE 110

#SMTP
ADD confs/postfix/ /etc/postfix
RUN chmod a+x /etc/postfix/postfix_init.sh
EXPOSE 25

#DNS
ADD confs/bind9 /etc/bind
COPY confs/resolv/resolv.conf /etc/resolv.conf

#SCRIPTS
ADD confs/scripts /root

#Supervisor daemon
RUN mkdir -p /var/run/sshd /var/run/dovecot /var/run/lighttpd /var/run/inetd /var/log/supervisor
COPY confs/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
