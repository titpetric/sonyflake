all:
	@echo 'Usage: make <prepare|build-go|build-docker>'

build-go: build/sonyflake build/sonyflake.exe
	@echo "Build finished"

build/sonyflake:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/sonyflake main.go
	cd build && tar -zcvf sonyflake_linux_64bit.tgz sonyflake && cp sonyflake .. && cd ..

build/sonyflake.exe:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o build/sonyflake.exe main.go
	cd build && tar -zcvf sonyflake_windows_64bit.tgz sonyflake.exe && cd ..

build-docker:
	docker build --rm -t titpetric/sonyflake --build-arg GITVERSION=${CI_COMMIT_ID} --build-arg GITTAG=${CI_TAG_ID} .

prepare:
	@rm -rf build && mkdir build
	@echo "Build folder prepared"

.PHONY: all build-docker prepare