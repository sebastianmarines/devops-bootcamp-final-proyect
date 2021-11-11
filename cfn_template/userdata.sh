#!/bin/bash -xe

echo "Mounting EBS"
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${ElasticFileSystem}.efs.${AWS::Region}.amazonaws.com:/ /var/www/wordpress

cd /var/www/wordpress

# Create MySQL database if it doesn't exist
echo "Creating MySQL database"
mysql -h ${RDS.Endpoint.Address} -u ${RDSMasterUsername} -p${RDSMasterPassword} -e "CREATE DATABASE IF NOT EXISTS wordpress;"


if ! /usr/local/bin/wp core is-installed --allow-root > /dev/null 2>&1; then
  /usr/local/bin/wp core download --locale=es_ES
  /usr/local/bin/wp config create --dbname=wordpress --dbuser=${RDSMasterUsername} --dbpass=${RDSMasterPassword} --dbhost=${RDS.Endpoint.Address} --dbprefix=wp_ --allow-root
  /usr/local/bin/wp core install --url=${LoadBalancer.DNSName} --title=Blog --admin_user=${WPAdminUsername} --admin_password=${WPAdminPassword} --admin_email=${WPAdminEmail} --allow-root
  chown -R nginx:nginx /var/www/wordpress
  /usr/bin/find /var/www/wordpress/ -type d -exec chmod 750 {} \;
  /usr/bin/find /var/www/wordpress/ -type f -exec chmod 640 {} \;
fi