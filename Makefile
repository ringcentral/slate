.PHONY: server
server:
	bundle exec middleman server

.PHONY: build
build:
	rake build