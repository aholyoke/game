
docker-build:
	docker build -t game .

docker-login:
	aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 448047001996.dkr.ecr.ca-central-1.amazonaws.com

docker-push:
	docker push 448047001996.dkr.ecr.ca-central-1.amazonaws.com/game:latest

docker-run:
	docker run -p 127.0.0.1:80:80 game python -m http.server 80

docker-run-bash:
	docker run -it -p 127.0.0.1:80:80 game bash
