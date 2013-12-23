#!/bin/bash
#TODO : vérifier l'existence d'une version précédente de poche
#TODO : English version
#TODO : Installation par MySQL/MariaDB/PostgreSQL

echo -e "Installation de poche dans ce dossier...\nTéléchargement commencé."
wget "http://r.cdetc.fr/latest-poche"
echo -e "Téléchargement terminé"
unzip latest-poche
echo -e "Décompression effectuée"
mv poche-* poche
cd poche
#ls
#Twig Install
echo -e "Installation de Twig, cela peut prendre du temps."
curl -s http://getcomposer.org/installer | php
php composer.phar install
#Config
mv inc/poche/config.inc.php.new inc/poche/config.inc.php
#Random salt with urandom
salt=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c20;`
#config file edition
sed "s/define ('SALT', '');/define ('SALT', '$salt');/" inc/poche/config.inc.php -i

#ask for database type
#selon celui choisi, tester l'existence de la DB
echo -e "Quel système de base de données souhaitez-vous utiliser ?\n [1] SQLite\n [2] MySQL/MariaDB\n [3] PostgreSQL\n\nSi vous ignorez quel système de base de donner utiliser, nous vous conseillons SQLite."
read db
case $db in 
	1) 
		command -v sqlite3 >/dev/null 2>&1 || { echo >&2 "Vous avez choisi SQLite mais il n'est pas installé. Annulation."; exit 1; }
		echo -e "SQLite est installée.\nUtilisation de SQLite..."
		mv install/poche.sqlite db/
		;;
	2)
		command -v mysql >/dev/null 2>&1 || { echo >&2 "Vous avez choisi MySQL/MariaDB mais il n'est pas installé. Annulation."; exit 1; } 
		echo -e "MySQL/MariaDB est installée.\nPour l'utiliser, executez install/mysql.sql et entrez dans le fichier de configuration les informations de connexion."
		;;
	3)
		command -v postgres >/dev/null 2>&1 || { echo >&2 "Vous avez choisi PostgreSQL mais il n'est pas installé. Annulation."; exit 1; }
		echo "PostgreSQL est installé.\nPour l'utiliser, executez install/postgres.sql et entrez dans le fichier de configuration les informations de connexion."
		;;
esac
echo "Mise en place des droits d'écriture..."
chmod 777 -R assets/ cache/ db/
echo "Suppression des fichiers d'installation..."
if [ $db = 1 ]
then 
	rm -r install/
fi
rm -r ../latest-poche
echo "Script d'installation terminé."
if [ $db != 1 ] 
then
	echo "Il vous reste à mettre en place la base de donnée avant de pouvoir utiliser poche."
fi
