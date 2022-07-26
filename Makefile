export GOFLAGS := -mod=vendor
export GO111MODULE := on
export GOPROXY := off
export GOSUMDB := off

branch := $(shell git rev-parse --abbrev-ref HEAD)
tag := $(shell git describe --abbrev=0 --tags)
rev := $(shell git rev-parse --short HEAD)

golangci-lint := golangci-lint

gosrc := $(shell find cmd internal -name "*.go")

gobin := $(strip $(shell go env GOBIN))
ifeq ($(gobin),)
gobin := $(shell go env GOPATH)/bin
endif

ldflags := -ldflags "-X github.com/subvillion/noti/internal/command.Version=$(branch)-$(rev)"
ldflags_rel := -ldflags "-s -w -X github.com/subvillion/noti/internal/command.Version=$(tag)"

cmd/noti/noti: $(gosrc) vendor
	go build -race -o $@ $(ldflags) github.com/subvillion/noti/cmd/noti

vendor: go.mod go.sum
	go mod vendor

release/noti.linuxrelease: $(gosrc) vendor
	mkdir --parents release
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
		go build -o $@ $(ldflags_rel) github.com/subvillion/noti/cmd/noti
release/noti$(tag).linux-amd64.tar.gz: release/noti.linuxrelease
	tar czvf $@ --transform 's#$<#noti#g' $<

release/noti.darwinrelease: $(gosrc) vendor
	mkdir -p release
	GOOS=darwin GOARCH=amd64 \
		go build -o $@ $(ldflags_rel) github.com/subvillion/noti/cmd/noti
release/noti$(tag).darwin-amd64.tar.gz: release/noti.darwinrelease
	tar czvf $@ --transform 's#$<#noti#g' $<

release/noti.windowsrelease: $(gosrc) vendor
	mkdir --parents release
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 \
		go build -o $@ $(ldflags_rel) github.com/subvillion/noti/cmd/noti
release/noti$(tag).windows-amd64.tar.gz: release/noti.windowsrelease
	tar czvf $@ --transform 's#$<#noti.exe#g' $<

docs/man/noti.1: docs/man/noti.1.md
	pandoc -s -t man $< -o $@
docs/man/noti.yaml.5: docs/man/noti.yaml.5.md
	pandoc -s -t man $< -o $@

.PHONY: build
build: cmd/noti/noti

.PHONY: install
install: cmd/noti/noti
	mv cmd/noti/noti $(gobin)

.PHONY: lint
lint:
	go vet ./...
	$(golangci-lint) run --no-config --exclude-use-default=false --max-same-issues=0 \
	--timeout 15s \
	--disable errcheck \
	--disable stylecheck \
	--enable bodyclose \
	--enable golint \
	--enable interfacer \
	--enable unconvert \
	--enable dupl \
	--enable gocyclo \
	--enable gofmt \
	--enable goimports \
	--enable misspell \
	--enable lll \
	--enable unparam \
	--enable nakedret \
	--enable prealloc \
	--enable scopelint \
	--enable gocritic \
	--enable gochecknoinits \
	./...

.PHONY: test
test:
	go test -v -cover -race $$(go list ./... | grep -v "noti/tests")

.PHONY: test-integration
test-integration:
	go install \
		-ldflags "-X github.com/subvillion/noti/internal/command.Version=$(branch)-$(rev)" \
		github.com/subvillion/noti/cmd/noti
	go test -v -cover ./tests/...

.PHONY: clean
clean:
	go clean
	rm -f cmd/noti/noti
	rm -rf release/
	git clean -x -f -d

.PHONY: man
man: docs/man/noti.1 docs/man/noti.yaml.5

.PHONY: release
release: release/noti$(tag).linux-amd64.tar.gz release/noti$(tag).windows-amd64.tar.gz

.PHONY: release-darwin
release-darwin: release/noti$(tag).darwin-amd64.tar.gz
