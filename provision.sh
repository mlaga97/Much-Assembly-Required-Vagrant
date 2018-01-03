# Update package lists
apt-get update

# Preconfigure MySQL
debconf-set-selections <<< 'mysql-server mysql-server/root_password password mar'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mar'

# Install Packages
apt-get -y install apache2 maven mysql-server php7.0 openjdk-8-jdk libapache2-mod-php php-mcrypt php-mysql mongodb

# Go to the appropriate directory
cd /vagrant

# Clone repositories
if [[ ! -d Much-Assembly-Required ]]; then
	git clone https://github.com/simon987/Much-Assembly-Required.git
fi

if [[ ! -d Much-Assembly-Required-Frontend ]]; then
	git clone https://github.com/simon987/Much-Assembly-Required-Frontend.git
fi

# Set up the database
mysql -u root -pmar -e "CREATE DATABASE mar;";
mysql -u root -pmar -e "CREATE USER 'mar'@'localhost' IDENTIFIED BY 'mar';"
mysql -u root -pmar -e "GRANT ALL PRIVILEGES ON mar.* TO 'mar'@'localhost' WITH GRANT OPTION;"
mysql -u root -pmar mar < Much-Assembly-Required-Frontend/database.sql

# Change apache config
sudo sed -i 's|/var/www|/vagrant/Much-Assembly-Required-Frontend|' /etc/apache2/apache2.conf
sudo sed -i 's|/var/www/html|/vagrant/Much-Assembly-Required-Frontend|' /etc/apache2/sites-enabled/000-default.conf

# Restart apache
systemctl restart apache2

# Build the server
cd /vagrant/Much-Assembly-Required/ && mvn package
