#/bin/bash -xe

if [ ! -f /usr/local/bin/wp ]; then
  echo "Installing wp-cli"
  curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
  chmod +x /usr/local/bin/wp
fi

echo "Mounting EBS"
mkdir -p /var/www/wordpress
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${ElasticFileSystem}.efs.${AWS::Region}.amazonaws.com:/ /var/www/wordpress

cd /var/www/wordpress

if ! /usr/local/bin/wp core is-installed --allow-root > /dev/null 2>&1; then
  /usr/local/bin/wp core download --locale=es_ES
  /usr/local/bin/wp config create --dbname=wordpress --dbuser=${RDSMasterUsername} --dbpass=${RDSMasterPassword} --dbhost=${RDS.Endpoint.Address} --dbprefix=wp_ --allow-root
  /usr/local/bin/wp core install --url=${SiteURL} --title=Blog --admin_user=${WPAdminUsername} --admin_password=${WPAdminPassword} --admin_email=${WPAdminEmail} --allow-root
fi