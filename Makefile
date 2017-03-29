all: build container push

build:
	@rm -f sonyflake
	CGO_ENABLED=0 GOOS=linux go build -o sonyflake main.go

container:
	docker build --rm -t titpetric/sonyflake --build-arg GITVERSION=${GITVERSION} .
	docker tag titpetric/sonyflake titpetric/sonyflake:${GITVERSION}

push:
	docker push titpetric/sonyflake:${GITVERSION}
	docker push titpetric/sonyflake:latest

.PHONY: all build container push