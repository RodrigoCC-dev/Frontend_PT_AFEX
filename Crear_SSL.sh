#! /bin/bash

# Cambio a carpeta home
cd ~

# Clonar acme.sh
git clone https://github.com/acmesh-official/acme.sh.git
cd acme.sh

# instalar dependencias
apt install -y cron socat

# Instalar acme.sh
echo '-------------------------------------------------'
echo 'Ingrese el correo electrónico a usar en acme.sh:'
read email
./acme.sh --install -m $email

# Emitir certificados
cd ~/.acme.sh
echo '---------------------------------------------'
echo 'Ingrese el dominio que usará la aplicación:'
read dominio
./acme.sh --issue -d $dominio -w /usr/share/nginx/html

# Copiar certificados creados en carpeta de acceso
mkdir /certificates
cp /root/.acme.sh/${dominio}/${dominio}.cer /certificates/cert_file.cer
cp /root/.acme.sh/${dominio}/${dominio}.key /certificates/key_file.key
