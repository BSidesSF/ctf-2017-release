PROJECT_NAME := bsides-sf-ctf-2017
REGISTRY := gcr.io

CONTAINER_TAG := ${REGISTRY}/${PROJECT_NAME}/steel-mountain
FIRMWARE_DIR := challenge/interface/htdocs/firmware

.PHONY: binaries containers push deploy delete all redeploy

# This is a more complicated 3-container build.

all: containers push delete deploy

binaries:
	make -C challenge/sensor
	make -C challenge/setpoint
	mkdir -p ${FIRMWARE_DIR}
	cp challenge/sensor/sensor.cgi ${FIRMWARE_DIR}/sensor
	cp challenge/setpoint/setpoint.cgi ${FIRMWARE_DIR}/setpoint

containers: binaries
	docker build --tag ${CONTAINER_TAG}-interface challenge/interface
	docker build --tag ${CONTAINER_TAG}-sensor challenge/sensor
	docker build --tag ${CONTAINER_TAG}-setpoint challenge/setpoint

push:
	gcloud docker -- push ${CONTAINER_TAG}-interface
	gcloud docker -- push ${CONTAINER_TAG}-sensor
	gcloud docker -- push ${CONTAINER_TAG}-setpoint

redeploy:
	kubectl delete -f deployment/deploy.yaml
	kubectl create -f deployment/deploy.yaml

deploy:
	kubectl create -f deployment/deploy.yaml

delete:
	kubectl delete -f deployment/deploy.yaml
