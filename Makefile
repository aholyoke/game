
docker-build:
	docker build -t game .

docker-login:
	aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 448047001996.dkr.ecr.ca-central-1.amazonaws.com

docker-push:
	docker tag game:latest 448047001996.dkr.ecr.ca-central-1.amazonaws.com/game:latest
	docker push 448047001996.dkr.ecr.ca-central-1.amazonaws.com/game:latest

docker-run:
	docker run -p 127.0.0.1:80:80 game flask run -p 80 -h 0.0.0.0

docker-run-bash:
	docker run -it -p 127.0.0.1:80:80 game bash

deploy:
	aws ecs update-service --cluster game-cluster --service sample-app-service --force-new-deployment
