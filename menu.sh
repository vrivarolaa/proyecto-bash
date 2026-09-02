#!/bin/bash

if [[ "$1" == "-d" ]]; then
    pkill -f consolidar.sh
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
    echo "3) Mostrar Alumnos"
    echo "4) Mostrar las 10 notas mas altas"
    echo "5) Mostrar datos de un alumo"
    echo "6) Visualizar log"
    echo "7) Salir"
}

Crear_entorno() {
    mkdir -p "$HOME/EPNro1/entrada"
    mkdir -p "$HOME/EPNro1/salida"
    mkdir -p "$HOME/EPNro1/procesado"
    cp consolidar.sh "$HOME/EPNro1/" 
    touch "$HOME/EPNro1/procesado.log"
    chmod +x "$HOME/EPNro1/consolidar.sh" 
}

Correr_proceso() {
    if [ -e "$HOME/EPNro1" ]; then
        bash "$HOME/EPNro1/consolidar.sh" > /dev/null 2>&1 & 
    else
        echo " Falta crear el entorno"
    fi
}


Mostrar_alumnos() {
    if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
        echo "Alumnos ordenados segun padron: "
        sort -n < "$HOME/EPNro1/salida/${FILENAME}.txt"
    else
        echo "Aun no hay datos"
    fi
}


Mostrar_notas_altas() {
    if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
        echo "Las 10 mejores notas"
        sort -n -r -k5 "$HOME/EPNro1/salida/${FILENAME}.txt" | head -n 10
    else
	echo "aun no hay datos"
    fi
}


Buscar_por_padron() {
    if [ ! -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
        echo "no hay datos aun"
    else
	read -p "Ingrese el numero de padron del alumo: " padron
	resultado=$(grep "^$padron " "$HOME/EPNro1/salida/${FILENAME}.txt")
		if [ -n "$resultado" ]; then
		    echo "$resultado"
		else
		    echo "numero de padron no encontrado"
		fi
    fi
}

Visualizar_log() {
    if [ -s "$HOME/EPNro1/procesado.log" ]; then
        cat "$HOME/EPNro1/procesado.log"
    else
        echo "No hay datos registrados aún."
    fi
}

Salir() {
    exit 0
}

while true; do
    Mostrar_menu
    read -p "Seleccione una opción del 1 al 7: " opcion 
    case $opcion in
        1) Crear_entorno ;;
        2) Correr_proceso ;;
        3) Mostrar_alumnos ;;
        4) Mostrar_notas_altas ;;
        5) Buscar_por_padron ;;
        6) Visualizar_log ;;
        7) Salir ;; 
    esac
done
