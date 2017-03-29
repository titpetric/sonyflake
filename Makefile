build:
	@rm -f sonyflake
	CGO_ENABLED=0 go build -o sonyflake main.go
	# build
	docker build --rm -t titpetric/sonyflake .
	docker tag titpetric/sonyflake titpetric/sonyflake:${GITVERSION}
	# push
	docker push titpetric/sonyflake:${GITVERSION}
	docker push titpetric/sonyflake:latest

.PHONY: build