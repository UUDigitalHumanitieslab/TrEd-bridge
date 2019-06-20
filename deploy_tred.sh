cd /hum/web/dhstatic.hum.uu.nl/htdocs/tred ;
rm -r extensions ;
mkdir extensions ;
cp -r /home/jvboheemen/extensions/. extensions ;
chown -R www-data:www-data extensions ;
chmod -R 777 extensions ;