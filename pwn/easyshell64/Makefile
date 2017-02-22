PROJECT_NAME := bsides-sf-ctf-2017
REGISTRY := gcr.io

# The full tag of the conatiner
CONTAINER_TAG := ${REGISTRY}/${PROJECT_NAME}/easyshell64

.PHONY: container push deploy delete deploy-service redeploy

# Build the docker conatiner with the appropriate tag, allowing us to push it to our registry
# The --no-cache argument builds the container from scratch, which is slow.
container:
	docker build --no-cache --tag ${CONTAINER_TAG} challenge

# Push the container to the google container registry.
# This is the first step in deploying the challenge
push:
	gcloud docker -- push ${CONTAINER_TAG}

# Deploy the challenge to kubernetes
deploy:
	kubectl create -f deployment/deploy.yaml

redeploy:
	# Errr... I guess this works
	kubectl delete -f deployment/deploy.yaml
	kubectl create -f deployment/deploy.yaml

# This is what exposes the container to the world
deploy-service:
	kubectl create -f deployment/service.yaml

# Delete the challenge from our cluster
delete:
	kubectl delete -f deployment/deploy.yaml
	kubectl delete -f deployment/service.yaml
