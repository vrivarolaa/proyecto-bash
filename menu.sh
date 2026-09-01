#!/bin/bash

if [[ "$1" == "-d" ]]; then
    pkill -f consolidar.sh     
    cp "$HOME/EPNro1/consolidar.sh" ./ 2>/dev/null
    cp "$HOME/EPNro1/procesado"/*.txt ./ 2>/dev/null
    rm -rf "$HOME/EPNro1"        
    exit 0
fi

if [ -z "$FILENAME" ]; then
    echo "Error: la variable FILENAME no está definida"
    exit 1
fi


base="$HOME/EPNro1"
if [ -e "$base/entrada" ]; then
    if [ "$1" == "-c" ]; then
        cp datos_alumnos.txt "$base/entrada/"
        echo "Datos de alumnos copiados a la entrada."
    fi
fi


Mostrar_menu() {
    echo "1) Crear Entorno"
    echo "2) Correr Proceso"
    echo "3) Mostrar Alumno"
    echo "4) Mostrar las 10 notas mas altas"
    echo "5) Mostrar datos de un alumo"
    echo "6) Visualizar log"
    echo "7) Salir"
}


    mkdir -p "$HOME/EPNro1/entrada"
    mkdir -p "$HOME/EPNro1/salida"
    mkdir -p "$HOME/EPNro1/procesado"
    cp consolidar.sh "$HOME/EPNro1/" 
    chmod +x "$HOME/EPNro1/consolidar.sh" 
}

correr_proceso(){
    if [ -f "$HOME/EPNro1/consolidar.sh" ]; then
        bash "$HOME/EPNro1/consolidar.sh" > /dev/null 2>&1 & 
    else
        echo " Falta crear el entorno"
    fi
}


mostrar_alumnnos(){
    if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
        echo "Alumnos ordenados segun padron: "
        sort -n < "$HOME/EPNro1/salida/${FILENAME}.txt"
    fi
}


mostrar_notas_altas (){
    if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
        echo "Las 10 mejores notas"
        sort -n -r -k5 "$HOME/EPNro1/salida/${FILENAME}.txt" | head -n 10
    fi
}


mostrar_datos (){
    if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
        read -p "Ingrese el numero de padron del alumo: " padron
        grep -E "^$padron\s" "$HOME/EPNro1/salida/${FILENAME}.txt"
    else
        echo "no hay datos aun"
    fi
}

visualizar_log() {
    if [ -f "$HOME/EPNro1/procesado.log" ]; then
        cat "$HOME/EPNro1/procesado.log"
    else 
        echo "No hay datos registrados aún."
    fi
}

salir(){
    exit
}

while true; do
    Mostrar_menu
    read -p "Seleccione una opción del 1 al 7: " opcion 
    case $opcion in
        1) Crear_entorno ;;
        2) correr_proceso ;;
        3) mostrar_alumnnos ;;
        4) mostrar_notas_altas ;;
        5) mostrar_datos ;;
        6) visualizar_log ;;
        7) salir ;; 
    esac
done