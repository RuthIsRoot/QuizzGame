#!/bin/bash

# Declaración variables colores output
WHITE='\033[1;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\00[1;34m'
NC='\033[0m' # No Color

displayMenu(){
        JUGADOR=$(whoami)
        echo -e "MENU DE OPCIONES\n=================\n"

        echo -e "1. Introducir preguntas/respuestas\n"
        echo -e "2. Jugar\n"
        echo -e "3. Ver puntuaciones\n"
        echo -e "4. Salir\n"

        echo -e "Elige una opción"
        read opc

        case $opc in
                1 | 1.)
                        echo -e "\n[*] Introduce la nueva pregunta :"
                        read PREGUNTA
                        while [ -z $PREGUNTA ]; do
                                echo -e "\n${RED}[!]${NC}No puedes dejar la pregunta vacia !"
                                echo -e "\n[*] Introduce la nueva pregunta :"
                                read PREGUNTA
                        done

                        echo -e "\n[*] Introduce la respuesta a la pregunta anterior :"
                        read RESPUESTA
                        while [ -z $RESPUESTA ]; do
                                echo -e "\n${RED}[!]${NC} No puedes dejar la respuesta vacia!"
                                echo -e "\n[*] Introduce la respuesta a la pregunta anterior"
                                read RESPUESTA
                        done

                        ;;

                2 |2.)
                        echo -e "FALTA HACER OPCION2"
                        ;;

                3 | 3.)
                        echo -e "FALTA HACER OPCION 3"
                        ;;

                4 | 4.)
                        echo -e "\nAdiós ${GREEN}${JUGADOR}${NC} ;)\n"
                        exit 1
                        ;;

                *)
                        clear
                        echo -e "${RED}${opc}${NC} No es una opción valida !\n"
                        displayMenu
                        ;;
        esac

}

displayMenu
