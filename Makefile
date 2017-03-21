build:
	@rm -f sonyflake
	CGO_ENABLED=0 go build -o sonyflake main.go
	docker build --rm -t titpetric/sonyflake .

push:
	docker push titpetric/sonyflake:latest

.PHONY: build