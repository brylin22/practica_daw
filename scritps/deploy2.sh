#!/bin/bash

# === VARIABLES ===
APP="hola"
BASE="/home/ubuntu/practica_daw"
TOMCAT="/var/lib/tomcat10/webapps"
API="/usr/share/tomcat10/lib/servlet-api.jar"

# === 1. ACTUALIZAR REPO ===
cd $BASE && git pull

# === 2. LIMPIAR BUILD ===
rm -rf build
mkdir -p build/WEB-INF/classes

# === 3. COMPILAR ===
javac -cp $API -d build/WEB-INF/classes src/hola/HolaServlet.java

# === 4. CREAR WAR ===
cd build
jar -cf $APP.war *

# === 5. COPIAR A TOMCAT ===
sudo cp $APP.war $TOMCAT/

# === 6. REINICIAR ===
sudo systemctl restart tomcat10

# === 7. COMPROBAR DESPLIEGUE ===
sleep 3
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/$APP/hola)

if [ "$STATUS" = "200" ]; then
    echo "Despliegue correcto ✅"
else
    echo "Error en el despliegue ❌ (HTTP $STATUS)"
fi
