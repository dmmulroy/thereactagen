.PHONY: snapshot
snapshot:
	dune build @snapshot --auto-promote

.PHONY: test
test:
	dune build @runtest

.PHONY: test-update
test-update:
	dune build @runtest --auto-promote
