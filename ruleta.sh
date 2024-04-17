#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
cyanColour='\033[1;36m'

function ctrl_c(){
    echo -e "\n\n${redColour}[!]${endColour} ${grayColour}Saliendo...${endColour}\n"
    tput cnorm; exit 1
}


# Ctrl+C
trap ctrl_c INT

function reusedCode1(){
    if [ "$random_number" -eq 0 ]; then 
        initial_bet=$(($initial_bet * 2))
        bad_plays+="$random_number "
            #echo -e "${redColour}[-]${endColour} ${grayColour}Ha salido el 0 portanto perdemos${endColour}\n"
        #money=$(($money - $initial_bet))
    else
        #echo -e "${greenColour}[+]${endColour} ${grayColour}El número que ha salido es par${endColour} ${greenColour}¡Ganas!${endColour}"
        reward=$(($initial_bet * 2))
        bad_plays=""
        #echo -e "${greenColour}[+]${endColour} ${grayColour}Ganas un total de${endColour} ${greenClour}$"$reward"${endColour}"
        money=$(($money + $reward))
        # echo -e "${greenColour}[+]${endColour} ${grayColour}Tienes${endColour} ${greenColour}$"$money"${endColour}"
        initial_bet=$backup_bet
    fi
}

function reusedCode2(){
    #echo -e "${redColour}[-]${endColour} ${grayColour}El número que ha salido es impar${endColour} ${redColour}Pierdes${endColour}"
    initial_bet=$(($initial_bet * 2))
    bad_plays+="$random_number "
    #echo -e "${redColour}[-]${endColour} ${grayColour}Ahora mismo te quedas con: $money${endColour}"
}
function helpPanel(){
    echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Uso:${endColour} ${purpleColour}$0${endColour}\n"
    echo -e "\t${blueColour}-m)${endColour} ${grayColour}Dinero con el que deseas jugar${endColour}"
    echo -e "\t${blueColour}-t)${endColour} ${grayColour}Técnica que vas a usar${endColour} ${yellowColour}(${endColour}${purpleColour}Martingala/InverseLabrouchere${endColour}${yellowColour})${endColour}\n"
}

function martingala(){

    numberBet='^-\?[0-9]+$'
    #echo -e "\n${greenColour}[+]${endColour} ${grayColour}Vamos a jugar con la técnica martingala${endColour}\n"
    echo -e "\n${blueColour}[+]${endColour} ${grayColour}Dinero actual:${endColour} ${greenColour}$"$money"${endColour}"
    echo -ne "\n${blueColour}[+]${endColour} ${grayColour}¿Cuánto dinero tienes pensado apostar? -> ${endColour}"  && read initial_bet
    echo -ne "\n${blueColour}[+]${endColour} ${grayColour}¿A qué deseas jugar continuamente?${endColour} ${yellowColour}(${endColour}${blueColour}par${endColour}${grayColour}/${endColour}${turquoiseColour}impar${endColour}${yellowColour})${endColour}${grayColour} ->${endColour} " && read par_impar
    echo -ne "\n${blueColour}[+]${endColour} ${grayColour}Vamos a juagar con una cantiadad inicial de:${endColour} ${greenColour}$"$initial_bet"${endColour} a "
    if [ "$par_impar" == "par" ]; then
        echo -e "${blueColour}$par_impar${endColour}\n"
    elif [ "$par_impar" == "impar" ]; then
        echo -e "${turquoiseColour}$par_impar${endColour}\n"
    
    else 
        echo -e "\n\n${redColour}[!]${endColour} ${grayColour}La opción ${redColour}$par_impar${endColour} ${grayColour}no existe${endColour} \n"
    fi 

    backup_bet=$initial_bet
    play_counter=1
    bad_plays=""

    tput civis #hidden cursor

    if  [[ "$initial_bet" =~ ^[0-9]+$ ]]; then

        while true; do
            money=$(($money-$initial_bet))
            #echo -e "${purpleColour}[+]${endColour} ${grayColour}Acabas de apostar${endColour} ${yellowColour}$"$initial_bet"${endColour} ${grayColour}y tienes${endColour} ${greenColour}$money${endColour}"
            
            random_number="$(($RANDOM % 37))"
            #echo -e "\n${blueColour}[+]${endColour} ${grayColour}Ha salido el número${endColour} ${cyanColour}${random_number}${endColour}"
            if [ ! "$money" -le 0 ]; then
                if [ "$par_impar" == "par"  ]; then
                    if [ "$(($random_number % 2))" -eq 0 ]; then
                        reusedCode1
                    else
                        reusedCode2
                    fi 
                    #sleep 
                elif [ "$par_impar" == "impar" ]; then
                    if [ ! "$(($random_number % 2))" -eq 0 ]; then
                        reusedCode1
                    else
                        reusedCode2
                    fi 

                else
                    flag=true
                
                    break   

                fi


            else

            if [ ! "$flag" == true ]; then

                echo -e "\n${redColour}[-] Se acabo el dinero${endColour}"
                echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Han habido un total de: ${endColour}${blueColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
                echo -ne "\n${redColour}[-]${endColour} ${grayColour}Jugadas malas -> ${endColour}"
                echo -e "${redColour}${blueColour}[${endColour} ${redColour}$bad_plays${endColour}${blueColour}]${endColour}\n"   
            fi
            tput cnorm; exit 0
            fi

            let play_counter+=1
        done
    else 
        echo -e "${redColour}[-]${endColour}${grayColour} Captura un número en la apuesta${endColour}\n"

    fi    


    tput cnorm #unhidden cursor
}

while getopts "m:t:h" arg; do

    case $arg in
        m) money=$OPTARG;;
        t) technique=$OPTARG;;
        h) helpPanel;;
    esac
done

if [ $money ] && [ $technique ]; then
    if [ "$technique" == "martingala" ]; then
        martingala
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}La técnica introducida no existe${endColour}\n"
    fi
else
    helpPanel
fi
