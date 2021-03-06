OWNER=graphql
IMAGE_NAME=gateway
QNAME=$(OWNER)/$(IMAGE_NAME)

TAG=$(QNAME):`echo $(TRAVIS_BRANCH) | sed 's/master/latest/;s/develop/unstable/' | sed 's/\//-/'`

lint:
	docker run -it --rm -v "$(PWD)/Dockerfile:/Dockerfile:ro" redcoolbeans/dockerlint

build:
	docker build -t $(TAG) .

login:
	@docker login -u "$(DOCKER_USER)" -p "$(DOCKER_PASS)"
push: login
	docker push $(TAG)

build-lambda:
	docker run --rm -v "$PWD":/var/task lambci/lambda:build-nodejs10.x rm -rf node_modules && npm i && zip -9yr lambda.zip .
