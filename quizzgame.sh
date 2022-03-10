#!/bin/bash

# Declaración variables colores output
WHITE='\033[1;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
NC='\033[0m' # No Color

displayMenu(){
        JUGADOR=$(whoami)
        echo -e "${WHITE}\nBIENVENIDO A TheQuizzGame ${GREEN}${JUGADOR}${NC} !\n${NC}"

        echo -e "${WHITE}MENU DE OPCIONES\n=================\n${NC}"

        echo -e "1. Introducir preguntas/respuestas\n"
        echo -e "2. Jugar\n"
        echo -e "3. Ver puntuaciones\n"
        echo -e "4. Salir\n"

        echo -e "${WHITE}Elige una opción :${NC}"
        read opc

        case $opc in
                1 | 1.)
                        checkint='^[0-9]+$'
                        x=0

                        echo -e "\n${WHITE}[?] Cuantas preguntas quieres añadir ?${NC}"
                        read NPREGUNTAS

                        while ! [[ $NPREGUNTAS =~ $checkint ]]; do
                                echo -e "\n${RED}[!]${NC} ${GREEN}${NPREGUNTAS}${NC} ${WHITE}no es un número de veces ! Introduce un número...${NC}"
                                echo -e "\n${WHITE}[?] Cuantas preguntas quieres añadir ?${NC}"
                                read NPREGUNTAS
                        done

                        while [ $x -lt $NPREGUNTAS  ]; do
                                echo -e "\n${WHITE}[*] Introduce la nueva pregunta :${NC}"
                                read PREGUNTA
                                while [[ -z $PREGUNTA ]]; do
                                        echo -e "${RED}[!]${NC} ${WHITE}No puedes dejar la pregunta vacia !${NC}"
                                        echo -e "\n${WHITE}[*] Introduce la nueva pregunta :${NC}"
                                        read PREGUNTA
                                done

                                echo -e "\n${WHITE}[*] Introduce la respuesta a la pregunta anterior :${NC}"
                                read RESPUESTA
                                while [[ -z $RESPUESTA ]]; do
                                        echo -e "${RED}[!]${NC} ${WHITE}No puedes dejar la respuesta vacia!${NC}"
                                        echo -e "\n${WHITE}[*] Introduce la respuesta a la pregunta anterior${NC}"
                                        read RESPUESTA
                                done

                                echo -e "\n${GREEN}[*]${NC} ${WHITE}Añadiendo pregunta y respuesta...${NC}"
                                echo $PREGUNTA >> preguntas.txt && echo $RESPUESTA >> respuestas.txt
                                if [ $? -ne 0 ]; then
                                        echo -e "\n${RED}[!] Algo ha fallado añadiendo tu pregutnas y respuesta !\n Saliendo...\n"
                                        exit 1
                                fi

                                x=$(( $x + 1 ))

                                if [ $x -ne $NPREGUNTAS ]; then
                                        REST=$((NPREGUNTAS-x))
                                        echo -e "${WHITE}[*] Todavia te quedan ${GREEN}${REST}${NC} ${WHITE}preguntas y respuestas para añadir${NC}"
                                else
                                        echo -e "\n${WHITE}[*] Ya has añadido tus ${GREEN}${NPREGUNTAS}${NC} ${WHITE}preguntas y respuestas !${NC}"
                                fi

                        done

                        echo -e "${BOLD}${GREEN}\n\tEspera 5 segundos para volver al menú.${NC}${NORMAL}"
                        sleep 5
                        clear
                        displayMenu
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
