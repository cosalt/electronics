# Run every lesson's testbench:  make test
LESSONS := $(sort $(wildcard lessons/[0-9]*))

.PHONY: test clean
test:
	@for d in $(LESSONS); do echo "== $$d"; $(MAKE) -s -C $$d sim || exit 1; done

clean:
	@for d in $(LESSONS); do $(MAKE) -s -C $$d clean; done
