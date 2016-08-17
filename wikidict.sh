#!/bin/bash

#-------------------------------------------------------------------#
# Data: 15 de agosto de 2016
# Criado por: Juliano Santos [x_SHAMAN_x]
# Script: wikidict.sh
# Descrição: Regex de busca, que procura palavras no 'wiktionary'
#-------------------------------------------------------------------#

SCRIPT="$(basename "$0")"
ref=0

# Requer parâmetro de busca
if [ ! "$1" ]; then 
	echo "Uso: $SCRIPT <palavra>"; exit 0; fi

# Suprime mensagens de erro
exec 2>/dev/null

# Substitui espaços da expressão por '_' e converte os caracteres acentuados do parâmetro para HTML encoding
match="$(echo "$*" | sed 's/ /_/g;s/À/%C3%80/g;s/Á/%C3%81/g;s/Â/%C3%82/g;s/Ã/%C3%83/g;s/Ä/%C3%84/g;s/Å/%C3%85/g;s/Æ/%C3%86/g;s/Ç/%C3%87/g;s/È/%C3%88/g;s/É/%C3%89/g;s/Ê/%C3%8A/g;s/Ë/%C3%8B/g;s/Ì/%C3%8C/g;s/Í/%C3%8D/g;s/Î/%C3%8E/g;s/Ï/%C3%8F/g;s/Ð/%C3%90/g;s/Ñ/%C3%91/g;s/Ò/%C3%92/g;s/Ó/%C3%93/g;s/Ô/%C3%94/g;s/Õ/%C3%95/g;s/Ö/%C3%96/g;s/×/%C3%97/g;s/Ø/%C3%98/g;s/Ù/%C3%99/g;s/Ú/%C3%9A/g;s/Û/%C3%9B/g;s/Ü/%C3%9C/g;s/Ý/%C3%9D/g;s/Þ/%C3%9E/g;s/ß/%C3%9F/g;s/à/%C3%A0/g;s/á/%C3%A1/g;s/â/%C3%A2/g;s/ã/%C3%A3/g;s/ä/%C3%A4/g;s/å/%C3%A5/g;s/æ/%C3%A6/g;s/ç/%C3%A7/g;s/è/%C3%A8/g;s/é/%C3%A9/g;s/ê/%C3%AA/g;s/ë/%C3%AB/g;s/ì/%C3%AC/g;s/í/%C3%AD/g;s/î/%C3%AE/g;s/ï/%C3%AF/g;s/ð/%C3%B0/g;s/ñ/%C3%B1/g;s/ò/%C3%B2/g;s/ó/%C3%B3/g;s/ô/%C3%B4/g;s/õ/%C3%B5/g;s/ö/%C3%B6/g;s/÷/%C3%B7/g;s/ø/%C3%B8/g;s/ù/%C3%B9/g;s/ú/%C3%BA/g;s/û/%C3%BB/g;s/ü/%C3%BC/g;s/ý/%C3%BD/g;s/þ/%C3%BE/g;s/ÿ/%C3%BF/g')"

echo -n "Pesquisando..."

# Lê a página
while read line
do
	[ $ref -eq 0 ] && echo -e '\nPalavra encontrada !!!\n'; echo "$line"; ((ref++))
	# Usa o 'curl' para ler o código da página usando codificação 'ASCII',
	# Aplica padrão da regex para remover as TAG's, uri, href; Extraindo o conteúdo
	# relevante. Remove o conteúdo do inicio da linha até tópico procurado e remove 
	# apartir do final do tópico até a última linha.
	# Gera um 'Descritor de arquivo', redirecionando para o while que lê e trata as linhas
done < <(curl --use-ascii https://pt.wiktionary.org/wiki/$match 2>/dev/null | \
		sed -n 's/[^>]*\([^<]*<\)[^>]*/\1/pg' | \
		sed 's/\(.*\)[[].*$/\1/g;s/\(<\|>\)//g;s/\(^(.*$\|^.*&.*;\)//g' | \
		sed '1,/Índice/d;/\(^Etimologia\|^Tradução\)/,$d;/^[0-9]/d;/./,/^$/!d')

# Se 'ref = 0', significa que não foi retornado nenhuma expressão 
if [ $ref -eq 0 ]; then
	echo -e "\n'$*': Não conheço essa palavra. Desculpe :("; fi

# fim
exit 0
