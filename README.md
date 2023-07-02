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
Generar archivo de variables de entorno de la aplicación copiando archivo .env-example a .env y editarlo:
```
cp .env-example .env
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
