.PHONY: test build fmt

test:
	dune exec -- gchat-reader messages.json

build:
	dune build

fmt:
	dune fmt
