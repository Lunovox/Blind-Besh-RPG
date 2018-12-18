#!/bin/bash

NARRADOR="ATIVADO"
DIFICULDADE="NORMAL"
FILE_BASE="${HOME}/.config/BlindBashRPG/"
FILE_SAVE="BlindBashRPG.sav"
FILE_CONF="BlindBashRPG.conf"
NOME=""
ANDAR=1
NIVEL=1
POCOES=0
HP_MAX=100
HP_NOW=100

function _OPEN_CONF () {
	if ! [ -e $FILE_BASE ]; then
		mkdir $FILE_BASE
		#echo $FILE_BASE
		#read -n 1
	fi
	
	#FILE_SAVE="BlindBashRPG.sav"
	#FILE_CONF="BlindBashRPG.conf"
	conf="${FILE_BASE}${FILE_CONF}"
	if [ -f $conf ]; then
		NARRADOR=$(cat $conf | grep "NARRADOR" | cut -d "=" -f 2 | tr -d " ")
		DIFICULDADE=$(cat $conf | grep "DIFICULDADE" | cut -d "=" -f 2 | tr -d " ")
	else
		_SAVE_CONF
	fi
}
function _SAVE_CONF () {
	conf="${FILE_BASE}${FILE_CONF}"
	echo "
	NARRADOR = ${NARRADOR} 
	DIFICULDADE = ${DIFICULDADE}
	" > $conf
}	
#----------------------------------------------------------------------
function _SAVE_GAME () {
	_CABECALHO
	conf="${FILE_BASE}${FILE_SAVE}"
	echo "
#-------------------
NOME = ${NOME}
ANDAR = ${ANDAR}
NIVEL = ${NIVEL}
POCOES = ${POCOES}
HP_NOW = ${HP_NOW}
HP_MAX = ${HP_MAX}
#-------------------
	" > $conf
	NARRA="Você anotou sua localização em um mapa que estava em seu bolso!"
	#echo $NARRA
	doFala "$NARRA" -p "$NARRA" -op "op"
	_CAUMA
}	
function _OPEN_GAME () {
	conf="${FILE_BASE}${FILE_SAVE}"
	if [ -f $conf ]; then
		NOME=$(cat $conf | grep "NOME" | cut -d "=" -f 2 | tr -d " ")
		ANDAR=$(cat $conf | grep "ANDAR" | cut -d "=" -f 2 | tr -d " ")
		NIVEL=$(cat $conf | grep "NIVEL" | cut -d "=" -f 2 | tr -d " ")
		POCOES=$(cat $conf | grep "POCOES" | cut -d "=" -f 2 | tr -d " ")
		HP_NOW=$(cat $conf | grep "HP_NOW" | cut -d "=" -f 2 | tr -d " ")
		HP_MAX=$(cat $conf | grep "HP_MAX" | cut -d "=" -f 2 | tr -d " ")
		_CABECALHO
		let HP_PERCENT="$HP_NOW * 100 / $HP_MAX"
		NARRA="
Você, $NOME, está no nível $NIVEL com a saúde em ${HP_PERCENT}%. 
Abriu sua mochila e contou $POCOES poções de cura. 
Retirou o mapa do bolso.
Leu suas anotações enquanto explorava o calabouço.
Descobriu que está no andar $ANDAR. 
		"
		#echo $NARRA
		#doFala "$NARRA" "op"
		doFala "$NARRA" -p "$NARRA" -op "op"
		_CAUMA
	else
		_CABECALHO
		NARRA="NÃO EXISTE JOGO SALVO!"
		##echo $NARRA
		if [ "$NARRADOR" == "ATIVADO" ]; then
			#doFala "$NARRA" 
			doFala "$NARRA" -p "$NARRA"
		else
			#doFala "$NARRA" "op"
			doFala "$NARRA" -p "$NARRA" -op "op"
		fi
		_MAIN
	fi
}
#----------------------------------------------------------------------
function _MAIN () {
	_CABECALHO
	LOADTEXT=""
	if [ -f "${FILE_BASE}${FILE_SAVE}" ]; then 
		LOADTEXT="(2) Carregar Jogo;"; 
	fi
	NARRA="
Selecione uma opção do menu principal:

	(1) Novo Jogo;
	${LOADTEXT}
	(3) Narrador: '$NARRADOR';
	(4) Dificuldade: '$DIFICULDADE';
	(5) Sair do Jogo;
	"
	#echo "$NARRA"
	doFala "$NARRA" -p "$NARRA" -op "op"
	#read -n 1 -p ">>> " op
	if [ "$op" == "1" ]; then 
		_NOVO;
	elif [ "$op" == "2" ]; then 
		_OPEN_GAME;
	elif [ "$op" == "3" ]; then 
		if [ "$NARRADOR" == "ATIVADO" ]; then
			NARRADOR="DESATIVADO"
			pkill 'espeak' > /dev/null
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "O narrador do jogo agora está '$NARRADOR'."
		else
			NARRADOR="ATIVADO"
		fi
		_MAIN;
	elif [ "$op" == "4" ]; then 
		if [ "$DIFICULDADE" == "GUGÚ-DADÁ" ]; then
			DIFICULDADE="BAIXA"
		elif [ "$DIFICULDADE" == "BAIXA" ]; then
			DIFICULDADE="NORMAL"
		elif [ "$DIFICULDADE" == "NORMAL" ]; then
			DIFICULDADE="ALTA"
		elif [ "$DIFICULDADE" == "ALTA" ]; then
			DIFICULDADE="INSANA"
		else
			DIFICULDADE="GUGÚ-DADÁ"
		fi
		_MAIN;
	elif [ "$op" == "5" ]; then 
		_SAIRDOJOGO
	else
		_MAIN
	fi
}
#----------------------------------------------------------------------

function _NOVO () {
	NOME=""
	ANDAR=1
	NIVEL=1
	POCOES=0
	HP_MAX=100
	HP=100
	_CABECALHO
	NARRA="Digite seu nome: "
	#printf "$NARRA"
	#doFala "$NARRA"
	doFala "$NARRA" -p "$NARRA" -val "NOME"
	#read -p ">>> " NOME
	NOME=$(echo "$NOME" | cut -d " " -f 1)
	_INIT
}
#----------------------------------------------------------------------
function _INIT () {
	_CABECALHO
	echo -e "DIFICULDADE: $DIFICULDADE\n\n"
	NARRA="
	A esposa do prefeito da cidade 'Crâneo-Rachado' foi raptada por Ogros. 
	Por isso, você, $NOME, foi convocado ou convocada para salvar a madame.
	Você desce por uma escadaria em um andar no subsolo escuro.
	"
	#echo "$NARRA"
	#doFala "$NARRA" "op"
	doFala "$NARRA" -p "$NARRA" -op "op"
	_CAUMA
}
#----------------------------------------------------------------------
function _CAUMA () {
	_CABECALHO
	NARRA="
O que você irá fazer?
	(1) Explorar o andar;
	(2) Autoexaminar-se;
	(3) Coletar o que encontrou;
	(4) Beber uma poção de cura;
	(5) Salvar o jogo;
	(6) Desistir da missão;
	"
	#echo "$NARRA"
	#doFala "$NARRA" "op"
	doFala "$NARRA" -p "$NARRA" -op "op"
	#read -n 1 -p ">>> " op
	if [ "$op" == "1" ]; then
		_EXPLORAR
	elif [ "$op" == "2" ]; then
		_AUTOEXAME
	elif [ "$op" == "3" ]; then
		_TAKEALL
	elif [ "$op" == "4" ]; then
		_CURAR
	elif [ "$op" == "5" ]; then
		_SAVE_GAME
	elif [ "$op" == "6" ]; then
		_OFFMISSION
	else
		_CAUMA
	fi
}
#----------------------------------------------------------------------
function _OFFMISSION () {
	_CABECALHO
	NARRA="
Você acha que já desceu demais, e não quer chegar do outro lado desta bandeija chamada 'planeta'. 
Então, resolve desistir da missão e voltar para a superfície.
	"
	#echo "$NARRA"
	#doFala "$NARRA"
	doFala "$NARRA" -p "$NARRA" -op "op"
	_MAIN
}
#----------------------------------------------------------------------
function _CABECALHO () {
	clear
	echo $x{0..75}"-"|tr -d ' '
	figlet "BLIND BASH RPG"
	echo $x{0..75}"-"|tr -d ' '
	echo "versão 2.0"
	echo $x{0..75}"-"|tr -d ' '
}
#----------------------------------------------------------------------
function _CARREGAR () {
	echo "carregar"
}
#----------------------------------------------------------------------
function _SAIRDOJOGO () {
	_SAVE_CONF
	_CABECALHO
	NARRA="Obrigado por jogar 'Blind Bash RPG'!"
	doFala "$NARRA" -p "$NARRA" -op "op"
	clear
	exit;
}
#----------------------------------------------------------------------
function doFala () {
	newprint=""
	newop=""
	newval=""
	if (( $# >= 2 )); then
		for (( i=1; i <= $#; ++i ))
		do
			next=$((i+1))
			if [[ "${!i}" == "-p" && -n "${!next}" ]]; then
				newprint="${!next}"
			elif [[ "${!i}" == "-op" && -n "${!next}" ]]; then
				newop=${!next}
			elif [[ "${!i}" == "-val" && -n "${!next}" ]]; then
				newval=${!next}
			fi
		done
	fi
	#echo "newprint=$newprint"
	if [ -n "$newprint" ]; then
		echo -e "$newprint"
	fi
	if [ -n "$newop" ]; then
		#echo "newop=$newop"
		if [ "$NARRADOR" == "ATIVADO" ]; then
			pkill 'espeak' > /dev/null
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$1" &
		fi
		read -n 1 -p ">>> " $newop
	elif [ -n "$newval" ]; then
		#echo "newval=$newval"
		if [ "$NARRADOR" == "ATIVADO" ]; then
			pkill 'espeak' > /dev/null
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$1" &
		fi
		read -p ">>> " $newval
	else
		if [ "$NARRADOR" == "ATIVADO" ]; then
			pkill 'espeak' > /dev/null
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$1"
		fi
	fi
}
#----------------------------------------------------------------------

_OPEN_CONF
_CABECALHO
	#doFala "Jogo 'Blind Bash RPG' versão dois ponto zero..."
	clear
_MAIN
