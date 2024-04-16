APP=$(basename $(shell git remote get-url origin))
REGISTRY=vshpelyk
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64
format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/vshpelyk/kbot.appVersion=${VERSION}

image: 
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clear:
	rm -rf kbot