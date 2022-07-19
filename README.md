# Servidor de protocolos de Red - Laboratorio de Redes - Universidad ORT Uruguay

Este repo contiene los elementos para construir y correr una imagen containerizada del servidor del Laboratorio de Redes.

## Funcionamiento

Si se tiene instalado [docker](https://www.docker.com/) y [docker compose](https://docs.docker.com/compose/) simplemente hay que hacer:

`docker compose up`

en el diretorio principal. Esto:

* Construye una imagen del servidor haciendo docker build (en caso de que no esté ya construida).
* Crea una red local en la IP 172.20.0.0/24 y coloca al servidor en la IP 172.20.0.2.
* Pone a correr todos los servicios.

Para apagar el servidor y limpiar las instancias creadas simpolemente hacer:

`docker compose down`

## Servicios disponibles

* HTTP: Servidor HTTP (lighttpd) en puerto 80. Probar navegar a http://172.20.0.2/ para ver el sitio del lab.
* SMTP: Servidor SMTP (postfix) con cuentas para usuarios locales tipo `ort-grupoX@mail.lab.ort.edu.uy` con `X` de 1 a 4.
* POP3: Servidor POP3 (dovecot) para leer el mail de estas mismas cuentas.
* FTP: Servidor FTP y archivos de prueba en `/home/publico/`
* TELNET: Servidor TELNET.
* SSH: Servidor SSH.
* DNS: Servidor DNS (bind9) que define la zona local y reversa lab.ort.edu.uy. A su vez funciona como servidor recursivo para hacer consultas a los servidores raíz y poder capturar las consultas intermedias.

## Usuarios disponibles

* `ort-grupoX` con igual password, X=1...4 para probar diferentes envíos de mail y opciones de login.
* `redes` con igual password y permiso de administrador (`sudo`) para ejecutar por ejemplo scripts que requieran permisos especiales.

## Consola al servidor en funcionamiento

Para acceder a una consola en el servidor:

* Loguearse por ssh con el usuario `redes:redes`. En este caso tenemos permiso de administrador a través de `sudo`.
* Ejecutar una terminal raíz directamente en el contenedor haciendo: 
  
  `docker exec -it <contenedor> /bin/bash`
  
  donde `<contenedor>` es el nombre del contenedor iniciado (típicamente `dockerserver-servidor_redes-1`).


## Ejecución rápida

Clonando este repo se construye la imagen de cero y se agregan y pueden ver y modificar todas las configuraciones en la carpeta `confs` a gusto.

Si simplemente se desea correr el servidor tal cual está publicado, se puede utilizar el siguiente 
[`docker-compose.yaml`](https://gist.github.com/aferragu/1c77dc774fb60013a2657da4301da855), que baja la imagen más reciente directo desde el registro de Github. A los efectos de correr el laboratorio esto es suficiente.

