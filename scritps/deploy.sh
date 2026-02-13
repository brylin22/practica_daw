#!/bin/bash

# ========================================
# Script de despliegue automático
# Autor: [brylin22]
# ========================================

# -------------------------------
# VARIABLES
# -------------------------------

REPO_DIR="/home/ubuntu/practica_daw"
SRC_DIR="$REPO_DIR/src"
BUILD_DIR="$REPO_DIR/build"
TOMCAT_WEBAPPS="/var/lib/tomcat10/webapps"
SERVLET_API="/usr/share/tomcat10/lib/servlet-api.jar"
APP_NAME="hola"

# -------------------------------
# 1. ACTUALIZAR REPOSITORIO
# -------------------------------

echo "Actualizando repositorio..."
cd $REPO_DIR || exit
git pull

# -------------------------------
# 2. LIMPIAR COMPILACIONES ANTERIORES
# -------------------------------

echo "Limpiando compilaciones anteriores..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/WEB-INF/classes

# -------------------------------
# 3. COMPILAR SERVLET
# -------------------------------

echo "Compilando servlet..."
javac -cp $SERVLET_API -d $BUILD_DIR/WEB-INF/classes $SRC_DIR/hola/HolaServlet.java

# -------------------------------
# 4. CREAR WEB.XML
# -------------------------------

echo "Creando web.xml..."
mkdir -p $BUILD_DIR/WEB-INF

cat <<EOF > $BUILD_DIR/WEB-INF/web.xml
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
         version="5.0">

    <servlet>
        <servlet-name>HolaServlet</servlet-name>
        <servlet-class>hola.HolaServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>HolaServlet</servlet-name>
        <url-pattern>/hola</url-pattern>
    </servlet-mapping>

</web-app>
EOF

# -------------------------------
# 5. GENERAR WAR
# -------------------------------

echo "Generando archivo WAR..."
cd $BUILD_DIR || exit
jar -cvf $APP_NAME.war *

# -------------------------------
# 6. COPIAR WAR A TOMCAT
# -------------------------------

echo "Copiando WAR a Tomcat..."
sudo cp $APP_NAME.war $TOMCAT_WEBAPPS/

# -------------------------------
# 7. REINICIAR TOMCAT
# -------------------------------

echo "Reiniciando Tomcat..."
sudo systemctl restart tomcat10

# -------------------------------
# 8. COMPROBAR DESPLIEGUE
# -------------------------------

echo "Comprobando despliegue..."
sleep 5
curl http://localhost:8080/$APP_NAME/hola

echo "Despliegue completado."

