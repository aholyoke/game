.PHONY: docker-build docker-login docker-push docker-run docker-run-bash deploy

docker-build:
	docker-compose build

docker-login:
	aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 448047001996.dkr.ecr.ca-central-1.amazonaws.com

docker-push: docker-login
	docker tag game:latest 448047001996.dkr.ecr.ca-central-1.amazonaws.com/game:latest
	docker push 448047001996.dkr.ecr.ca-central-1.amazonaws.com/game:latest

docker-up:
	docker-compose up

docker-exec:
	docker-compose up -d
	docker-compose exec web bash

deploy: docker-push
	terraform -chdir=terraform apply
