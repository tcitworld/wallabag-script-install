Warning
===
*Note that this is not longer needed since wallabag (ex-Poche) provides it's own installation script.*

See wallabag at [Github](https://github.com/wallabag/wallabag) or at it's own website : https://www.wallabag.org


Poche-Script-Install
====================

Poche-Script-Install is a shell script (BASH) which is made for simple installation of [poche](http://www.inthepoche.com). It downloads the last version and runs basic configuration and checking tasks.

There is two versions of the script, one in french, one in english.

Usage
-----
Put this script where poche should be executed (usally some place like /var/www/somefolder) and give it writing permissions (unix only) with the command : `chmod +x install-poche-xx.sh` where xx is your language.
Then execute it with `sudo ./install-poche-xx.sh`.

Remarks
-------
The use of sudo is here to install the php dependencies (twig).

For now, the script only fully does the installation when SQLite is selected. You'll have to do extra tasks if you choose the MySQL/MariaDB/PostgreSQL database system.
