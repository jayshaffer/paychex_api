set -e

docker-compose build
docker-compose up -d
docker-compose run -T web bin/jenkins
