#!/bin/bash
#TODO : Check if previous poche installation
#TODO : MySQL/MariaDB/PostgreSQL installation

echo -e "poche installation in this folder...\nStarted download"
wget "http://inthepo.ch/e/latest"
echo -e "Finished Download"
unzip latest-poche
echo -e "Finished unpacking"
mv poche-* poche
cd poche
#Twig Install
echo -e "Twig installation, this may take some time."
curl -s http://getcomposer.org/installer | php
php composer.phar install
#Config
mv inc/poche/config.inc.php.new inc/poche/config.inc.php
#Random salt with urandom
salt=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c20;`
#config file edition
sed "s/define ('SALT', '');/define ('SALT', '$salt');/" inc/poche/config.inc.php -i

#ask for database type
#test database system is existing on system
echo -e "Which database system do you want to use?\n [1] SQLite\n [2] MySQL/MariaDB\n [3] PostgreSQL\n\nIf you don't know which one, we advise you to choose SQLite."
read db
case $db in 
	1) 
		command -v sqlite3 >/dev/null 2>&1 || { echo >&2 "You chose SQLite but it isn't installed. Exiting."; exit 1; }
		echo -e "SQLite is installed.\nUsing SQLite..."
		mv install/poche.sqlite db/
		;;
	2)
		command -v mysql >/dev/null 2>&1 || { echo >&2 "You chose MySQL/MariaDB but it isn't installed. Exiting."; exit 1; } 
		sed "s/define ('STORAGE', 'sqlite');/define ('STORAGE', 'mysql');/" inc/poche/config.inc.php -i 
		echo -e "MySQL/MariaDB is installed.\nTo use it, execute install/mysql.sql and enter in the configuration file the database credentials."
		;;
	3)
		command -v postgres >/dev/null 2>&1 || { echo >&2 "You chose PostgreSQL but it isn't installed. Exiting."; exit 1; }
		sed "s/define ('STORAGE', 'sqlite');/define ('STORAGE', 'postgres');/" inc/poche/config.inc.php -i 
		echo "PostgreSQL is installed.\nTo use it, execute install/postgres.sql and enter in the configuration file the database credentials."
		;;
esac
echo "Write access setup..."
chmod 777 -R assets/ cache/ db/
echo "Erasing installation files..."
if [ $db = 1 ]
then 
	rm -r install/
fi
rm -r ../latest-poche
echo "End of installation script !"
if [ $db != 1 ] 
then
	echo "You still need to setup the database system before starting using poche."
fi
