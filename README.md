# Frontend_PT_AFEX

## Entorno de desarrollo
* NodeJS v18.16
* npm v9.6.7
* VueJS v3.3.4

## Instalación
La siguiente descripción de instalación se realiza considerando un sistema local con Ubuntu 20.04. Para otras distribuciones de sistemas operativos pueden haber variaciones en los comandos indicados.
### nvm-sh
*nvm-sh* es una herramienta que permite instalar múltiples versiones de NodeJS en el sistema, por lo cual permite elegir la versión específica a utilizar. Para su instalación se debe contar con cURL instalado:
```
sudo apt update
sudo apt install curl
```
Instalar *nvm-sh* a través del script de instalación proporcionado en la documentación oficial:
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
```
Ejecutar el siguiente comando para que la consola del sistema reconozca las instrucciones de *nvm-sh* en las siguientes sesiones de trabajo:
```
source ~/.bashrc
```
Cerrar la sesión actual y volver a abrir la consola para continuar con la instalación.

### Node.js
Con la ayuda de *nvm-sh* ya es posible instalar la versión de *NodeJS* requerida a través del siguiente comando:
```
nvm install 18.16
```
Verificar la versión de *NodeJS* instalada:
```
node --version
```
Verificar la versión de npm instalada:
```
npm --version
```
### Clonar repositorio, instalar dependencias y desplegar en entorno de desarrollo
Clonar el repositorio e ingresar al directorio de la aplicación:
```
git clone https://github.com/RodrigoCC-dev/Frontend_PT_AFEX.git frontend_pt_afex
cd frontend_pt_afex
```
Instalar las dependencias:
```
npm install
```
Generar archivo de variables de entorno de la aplicación copiando archivo .env_example a .env y editarlo:
```
cp .env_example .env
nano .env
```
Cambiar valores de variables de entorno:
```
VITE_API_KEY='Tu_clave_API_KEY'                     # Para las consultas a la API de Youtube
VITE_BACK_DIR='Dirección_de_la_aplicación_Backend'  # Dirección host del backend
```
Desplegar la aplicación en entorno de desarrollo:
```
npm run dev
```

## Despliegue para producción
### Instalación directa en el servidor
Las siguientes instrucciones de despliegue de la aplicación son las correspondientes para un servidor con distribución Ubuntu 20.04. Para otros sistemas operativos pueden haber variaciones en los comandos indicados. Se considera que ya se cuenta con la instalación de las dependencias señaladas en el apartado __Instalación__.

#### Instalación de Nginx
Instalar Nginx en el servidor:
```
sudo apt update
sudo apt install nginx
```
Habilitar el puerto 80 en el firewall de ubuntu para conexiones __http__ con Nginx:
```
sudo ufw allow 80/tcp
```
Verificar funcionamiento de Nginx:
```
sudo systemctl status nginx
```
#### Configuración de la aplicación en producción
Ingresar al directorio de trabajo. Para ejemplificar se utiliza la carpeta */opt* del sistema. Clonar el repositorio con permisos de superusuario:
```
cd /opt
sudo git clone https://github.com/RodrigoCC-dev/Frontend_PT_AFEX.git frontend_pt_afex
```
Cambiar los permisos de acceso a la carpeta de la aplicación e ingresar al directorio de la aplicación:
```
sudo chown -R tu-usuario.tu-usuario frontend_pt_afex
sudo chmod -R 775 frontend_pt_afex
cd frontend_pt_afex
```
Crear el archivo de variables de entorno de la aplicación:
```
cp .env_example .env
nano .env
```
Establecer los parámetros de entorno según los valores de producción:
```
VITE_API_KEY='Tu_clave_API_KEY'                     # Key de la API de Youtube para producción
VITE_BACK_DIR='Dirección_de_la_aplicación_Backend'  # Dirección host del backend
```
Instalar las dependencias y construir la aplicación:
```
npm install
npm run build
```
Copiar la aplicación construida al directorio de trabajo de Nginx:
```
cd dist
sudo cp -r ./ /usr/share/nginx/html
cd ..
```
Cambiar la configuración de Nginx a través del archivo de configuración de la aplicación y reiniciar el servicio con los siguientes comandos:
```
sudo cp ./nginx.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx
```

### Actualizar la aplicación
Para actualizar la aplicación a su versión más reciente se debe ingresar a la carpeta de la aplicación y ejecutar:
```
cd /opt/frontend_pt_afex
git pull
```
Instalar las nuevas dependencias de la aplicación y volver a construirla:
```
npm install
npm run build
```
Copiar la aplicación construida al directorio de trabajo de Nginx y reiniciarlo:
```
sudo cp -r dist /usr/share/nginx/html
sudo systemctl restart nginx
```

### Cambiar aplicación a HTTPS
Para poder habilitar el trafico __http__ seguro en la aplicación, es necesario obtener el certificado *SSL* del sitio. Para obtener este certificado, se ha incluído un *script* que permite obtenerlo a través de [Let's Encrypt](https://letsencrypt.org/es/), haciendo uso de __acme.sh__ para su obtención. Para mayor información, consultar la [documentación oficial de acme.sh](https://github.com/acmesh-official/acme.sh). El *script* requiere que la aplicación esté desplegada en el puerto *80* a través de *Nginx*.

Ingresar a la carpeta de la aplicación, otorgar permisos de ejecución al *script* y ejecutar:
```
cd /opt/frontend_pt_afex
sudo chmod 775 Crear_SSL.sh
./Crear_SSL.sh
```
Durante la ejecución del *script*, se creará la carpeta */certificates* donde quedarán guardados los archivos _*.key_ y _*.cer_ correspondientes.

Editar el archivo *nginx_ssl.conf* incluido en la carpeta raíz de la aplicación, señalando la ubicación de los archivos _.key_ y _.cer_ en las siguientes líneas:
```
ssl_certificate       /opt/frontend_pt_afex/certificates/cert_file.cer;
ssl_certificate_key   /opt/frontend_pt_afex/certificates/key_file.key;
```
Reemplazar la configuración de Nginx a través del nuevo archivo de configuración de la aplicación y reiniciar el servicio con los siguientes comandos:
```
sudo cp ./nginx_ssl.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx
```
Habilitar el puerto 443 en el firewall de ubuntu para conexiones __https__ con Nginx:
```
sudo ufw allow 443/tcp
```

## Casos de uso
En esta sección se presentan las capturas de pantalla de la aplicación, logradas siguiendo las imágenes referenciales del [Figma](https://www.figma.com/file/YSU5uOCfGtRW8YnrHtA9eA/Caso-de-prueba) requerido para este sistema.
### Vista *general*
[![Vista-General.png](https://i.postimg.cc/05XqsPBq/Vista-General.png)](https://postimg.cc/Z0NQPtmf)
### Vista *agregar video*
[![Vista-Agregar-video.png](https://i.postimg.cc/BnHWHDQq/Vista-Agregar-video.png)](https://postimg.cc/cvx5Nvnj)
### Vista *despliegue de descripción*
[![Vista-Despligue-de-descripci-n.png](https://i.postimg.cc/cLQjrSXC/Vista-Despligue-de-descripci-n.png)](https://postimg.cc/VJk4V3yP)
### Vista *confirmar eliminación*
[![Vista-Confirmar-eliminaci-n.png](https://i.postimg.cc/4y72ZkYJ/Vista-Confirmar-eliminaci-n.png)](https://postimg.cc/8fGmBYd3)
### Mensajes de error
#### Vista *video repetido*
[![ME-Video-repetido.png](https://i.postimg.cc/VsJz5JMN/ME-Video-repetido.png)](https://postimg.cc/grbCTkg9)
#### Vista *video inexistente*
[![ME-Video-inexistente.png](https://i.postimg.cc/Vs2mtzBW/ME-Video-inexistente.png)](https://postimg.cc/5j5hddrX)
#### Vista *enlace incorrecto*
[![ME-Enlace-incorrecto.png](https://i.postimg.cc/rpykTsMM/ME-Enlace-incorrecto.png)](https://postimg.cc/XrPhcVrz)
