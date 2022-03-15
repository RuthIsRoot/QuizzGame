	#!/bin/bash

	# Declaración variables colores output
	WHITE='\033[1;37m'
	GREEN='\033[1;32m'
	RED='\033[1;31m'
	BOLD=$(tput bold)
	NORMAL=$(tput sgr0)
	NC='\033[0m' # No Color

	addQuestions(){
			checkint='^[0-9]+$'
			x=0

			echo -e "\n${WHITE}[?] Cuantas preguntas quieres añadir ?${NC}"
			read NPREGUNTAS

			while ! [[ $NPREGUNTAS =~ $checkint ]]; do
					clear
					echo -e "\n${RED}[!]${NC} ${GREEN}${NPREGUNTAS}${NC} ${WHITE}no es un número de veces válido! Introduce un número y asegurate de que sea mayor que 0...${NC}"
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

					PREGUNTAEXISTE=$(grep -iF "${PREGUNTA}" preguntas.txt)

					if [ $? -eq 0 ]; then
							echo -e "\n${RED}[!]${NC} ${WHITE}Lo sentimos, la pregunta que has añadido ya existe en nuestras preguntas ';(\n\n\t[*] Introduce una nueva pregunta diferente...\n"
							echo -e "${BOLD}${GREEN}\n\tEspera 5 segundos para volver al menú.${NC}${NORMAL}"
							sleep 5
							clear
							displayMenu
					else
							echo $PREGUNTA >> preguntas.txt && echo $RESPUESTA >> respuestas.txt
							if [ $? -ne 0 ]; then
									echo -e "\n${RED}[!] Algo ha fallado añadiendo tu pregunta y respuesta ;(\n Saliendo...\n"
									exit 1
							else
									echo -e "\n${GREEN}[*]${NC} ${WHITE}Pregunta y respuesta añadidas !\n${NC}"
							fi
					fi

					x=$(( $x + 1 ))

					if [ $x -ne $NPREGUNTAS ]; then
							REST=$((NPREGUNTAS-x))
							echo -e "${WHITE}[*] Todavia te quedan ${GREEN}${REST}${NC} ${WHITE}preguntas y respuestas para añadir${NC}"
					else
							echo -e "${WHITE}[*] Ya has añadido tus ${GREEN}${NPREGUNTAS}${NC} ${WHITE}preguntas y respuestas !${NC}"
					fi

			done

			echo -e "${BOLD}${GREEN}\n\tEspera 5 segundos para volver al menú.${NC}${NORMAL}"
			sleep 5
			clear
			displayMenu
	}

	wrongQuestionsMenu(){
				echo -e "\n${GREEN}[*]${NC} ${WHITE}Que quieres hacer ?${NC}\n"

				echo -e "1. Introducir preguntas/respuestas\n"
				echo -e "2. Cambiar el número de preguntas a jugar\n"
				echo -e "3. Salir\n"

				echo -e "${GREEN}[*]${NC} ${WHITE}Elige una opción :${NC}"
				read opc

				case $opc in
					1 | 1.)
							clear
							addQuestions
							;;

					2 | 2.)
							clear
							play
							;;

					3 | 3.)
							echo -e "\nAdiós ${GREEN}${JUGADOR}${NC} ;)\n"
							exit 1
							;;

				*)
							clear
							echo -e "\n${RED}${opc}${NC} No es una opción valida ! Introduce una opción válida..."
							wrongQuestionsMenu
							;;
					esac
	}

	play(){
			
			checkint='^[0-9]+$'
			x=0
			TOTALPREGUNTAS=$(wc -l < preguntas.txt)

			if [ $TOTALPREGUNTAS -eq 0 ]; then
				echo -e "\n${RED}[!]${NC} ${WHITE}No puedes jugar si no has introducido ninguna pregunta ';)${NC}"
				echo -e "\n\t${GREEN}Vamos a solucionar eso, espera un momento ;)${NC}"

				sleep 5
				clear
				addQuestions
				exit 1
			fi

			echo -e "\n${GREEN}[*]${NC} ${WHITE}Introduce tu Nickname :${WHITE} "
			read JUGADOR

			while [[ -z $JUGADOR ]]; do
							clear
							echo -e "${RED}[!]${NC} ${WHITE}No puedes dejar tu Nickname vacio!${NC}"
							echo -e "${WHITE}[*] Introduce tu Nickname de nuevo${NC}"

							read JUGADOR
			done

			echo -e "${WHITE}\n[?] Cuantas preguntas quieres jugar ?${NC}"
			read NPREGUNTAS

			while ! [[ $NPREGUNTAS =~ $checkint ]]; do
				echo -e "\n${RED}[!]${NC} ${GREEN}${NPREGUNTAS}${NC} ${WHITE}no es un número válido! Introduce un número y asegurate que sea mayor que 0...${NC}"
				echo -e "\n${WHITE}[?] Cuantas preguntas quieres jugar ?${NC}"
				read NPREGUNTAS
			done

			if [ $TOTALPREGUNTAS -lt $NPREGUNTAS ]; then
				clear
				echo -e "\n${RED}[!]${NC} ${WHITE}Lo sentimos, no tenemos suficiente preguntas disponibles${NC}"
				echo -e "${WHITE}[*] Quieres jugar ${NC}${RED}${NPREGUNTAS}${NC}${WHITE} preguntas y tenemos ${NC}${GREEN}${TOTALPREGUNTAS}${NC}${WHITE} preguntas disponibles${NC}"

				wrongQuestionsMenu

				exit 1
			fi

			echo -e "${GREEN}\n\t[*] Estamos cargando tus preguntas...${NC}"
			
			sleep 1.5

			clear

			PUNTOS=0

			IFS=$'\n'
			for PREGUNTA in $(cat preguntas.txt | shuf -n ${NPREGUNTAS});
			do
					echo -e "${GREEN}[*] Pregunta ${NC}\n${WHITE}${PREGUNTA}${NC}"
					echo -e "\n${GREEN}[*] Respuesta${NC}"
					read RESPUESTA

					while [[ -z $RESPUESTA ]]; do
							clear
							echo -e "${RED}[!]${NC} ${WHITE}No puedes dejar la respuesta vacia!${NC}"
							echo -e "${WHITE}[*] Introduce la respuesta a la pregunta\n${NC}"

							echo -e "${GREEN}[*] Pregunta ${NC}\n${WHITE}${PREGUNTAS[$x]}${NC}"
							echo -e "\n${GREEN}[*] Respuesta${NC}"
							read RESPUESTA
					done

					LINEAPREGUNTA=$(awk 'match($0,v){print NR; exit}' v="${PREGUNTA}" preguntas.txt)
					RESPUESTACORRECTA=$(sed -n ${LINEAPREGUNTA}p respuestas.txt)

					RESPUESTA=$(grep -iF "${RESPUESTA}" respuestas.txt)

					if [ "${RESPUESTA}" = "${RESPUESTACORRECTA}" ]; then
							PUNTOS=$(( $PUNTOS + 1 ))
					fi

					x=$(( $x + 1 ))

					if [ $x -ne $NPREGUNTAS ]; then
							REST=$((NPREGUNTAS-x))
							clear
							echo -e "${WHITE}[*] Todavia te quedan ${GREEN}${REST}${NC} ${WHITE}preguntas por jugar !\n${NC}"
					else
							clear
							echo -e "${WHITE}[*] Ya has contestado las ${GREEN}${NPREGUNTAS}${NC} ${WHITE}preguntas !${NC}"
							echo -e "\n${WHITE}[*] De las ${GREEN}${NPREGUNTAS}${NC} ${WHITE}preguntas jugadas has contestado ${GREEN}${PUNTOS}${NC}${WHITE} correctamente${NC}"

							sleep 3
					fi
			done
			unset IFS

			if [ ${PUNTOS} -gt 0 ]; then
				echo "${JUGADOR} == ${PUNTOS} puntos" >> puntuacion.txt
			fi
			

			echo -e "${BOLD}${GREEN}\n\tEspera 5 segundos para volver al menú.${NC}${NORMAL}"
			sleep 5
			clear
			displayMenu
	}

	displayMenu(){
			clear
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
							addQuestions
							;;

					2 | 2.)
							play
							;;

					3 | 3.)
							clear
							echo -e "${WHITE}TOP 5 MEJORES JUGADORES${NC}"
							echo -e "=======================\n"

							ORDENAR=$(sort -t " " -nr -k 3 puntuacion.txt -o puntuacion.txt)
							$ORDENAR
							head -n 5 puntuacion.txt

							echo -e "\n${WHITE}[*] Presiona cualquier tecla para volver al menú principal...${NC}"
							read -n 1 -s -r
							clear
							displayMenu
							;;

					4 | 4.)
							echo -e "\n${WHITE}Adiós${NC} ${GREEN}${JUGADOR}${NC} ;)\n"
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
