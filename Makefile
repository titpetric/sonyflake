build:
	docker build --rm -t titpetric/sonyflake .
	docker push titpetric/sonyflake:latest

.PHONY: build