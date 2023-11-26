#!/bin/bash
# Author: M S Rahman
# Collaborator: Emmanuel Okonkwo

# Check if the user is running the script as root
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

# Stop any running docker-compose processes
docker-compose down

# Remove the old version of docker-compose
apt-get remove docker-compose
sudo rm /usr/local/bin/docker-compose
pip uninstall docker-compose

# Install the latest version of docker-compose
apt-get update && apt install curl wget zip unzip sudo git -y
# curl + grep
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION

# Update docker compose plugin
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
docker compose version

# Verify the installation
docker-compose --version

# Install defectDojo
git clone https://github.com/DefectDojo/django-DefectDojo
cd django-DefectDojo
# building
./dc-build.sh
# running (for other profiles besides postgres-redis look at https://github.com/DefectDojo/django-DefectDojo/blob/dev/readme-docs/DOCKER.md)
./dc-up-d.sh mysql-redis
# obtain admin credentials. the initializer can take up to 3 minutes to run
# use docker-compose logs -f initializer to track progress
docker compose logs initializer | grep "Admin password:"
