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

                        clear

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

                                clear

                                echo -e "\n${GREEN}[*]${NC} ${WHITE}Pregunta y respuesta añadidas !\n${NC}"
                                echo $PREGUNTA >> preguntas.txt && echo $RESPUESTA >> respuestas.txt
                                if [ $? -ne 0 ]; then
                                        echo -e "\n${RED}[!] Algo ha fallado añadiendo tu pregunta y respuesta ;(\n Saliendo...\n"
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
                        checkint='^[0-9]+$'
                        x=0
                        TOTALPREGUNTAS=$(wc -l < preguntas.txt)

                        if [ $TOTALPREGUNTAS -eq 0 ]; then
                                echo -e "\n${RED}[!]${NC} ${WHITE}No puedes jugar si no has introducido ninguna pregunta ';)${NC}"
                                echo -e "\n\t${GREEN}Vamos a solucionar eso, espera un momento ;)${NC}"

                                sleep 5
                                clear
                                displayMenu
                        fi

                        echo -e "\n${WHITE}[?] Cuantas preguntas quieres jugar ?${NC}"
                        read NPREGUNTAS

                        while ! [[ $NPREGUNTAS =~ $checkint ]]; do
                                echo -e "\n${RED}[!]${NC} ${GREEN}${NPREGUNTAS}${NC} ${WHITE}no es un número ! Introduce un número...${NC}"
                                echo -e "\n${WHITE}[?] Cuantas preguntas quieres jugar ?${NC}"
                                read NPREGUNTAS
                        done

                        if [ $TOTALPREGUNTAS -lt $NPREGUNTAS ]; then
                                echo -e "\n${RED}[!]${NC} ${WHITE}Lo sentimos, no tenemos suficiente preguntas disponibles${NC}"
                                echo -e "${WHITE}[*] Quieres jugar ${NC}${RED}${NPREGUNTAS}${NC}${WHITE} preguntas y tenemos ${NC}${GREEN}${TOTALPREGUNTAS}${NC}${WHITE} preguntas disponibles${NC}"
                        fi

                        ;;

                3 | 3.)
                        clear
                        echo -e "${WHITE}TOP 5 MEJORES JUGADORES${NC}"
                        echo -e "=======================\n"

                        ORDENAR=$(sort -t " " -nr -k 3 puntuacion.txt -o puntuacion.txt)
                        $ORDENAR
                        tail -n 5 puntuacion.txt

                        echo -e "\n${WHITE}[*] Presiona cualquier tecla para volver al menú principal...${NC}"
                        read -n 1 -s -r
                        clear
                        displayMenu
                        ;;

                4 | 4.)
                        echo -e "\nAdiós ${GREEN}${JUGADOR}${NC} ;)\n"
                        exit 1
                        ;;

                *)
                        clear
                        echo -e "${RED}${opc}${NC} No es una opción valida !"
                        displayMenu
                        ;;
        esac

}

displayMenu
