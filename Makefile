
BIN = umq
BINS = push recv help
EXAMPLES = wall-server histo-server
PREFIX ?= /usr/local
MANPREFIX ?= $(PREFIX)/share/man/man1

$(BIN): clean $(BINS)
	ln -s $(BIN).sh $(BIN)

$(BINS):
	ln -s $@.sh umq-$@

install: $(BIN)
	@echo "  +bin"
	@install $(BIN) $(PREFIX)/bin
	$(foreach bin,$(BINS),$(shell install umq-$(bin) $(PREFIX)/bin/umq-$(bin)))
	@echo "  +doc"
	@install $(BIN).1 $(MANPREFIX)
	$(foreach bin,$(BINS),$(shell install umq-$(bin).1 $(MANPREFIX)))

uninstall: clean
	@echo "  -bin"
	@rm -f $(PREFIX)/bin/$(BIN)
	$(foreach bin,$(BINS),$(shell rm -f $(PREFIX)/bin/umq-$(bin)))
	@echo "  -doc"
	$(foreach bin,$(BINS),$(shell rm -f $(MAXPREFIX)/umq-$(bin).1))
	@echo "  -examples"
	$(foreach bin,$(BINS),$(shell rm -f $(PREFIX)/bin/$(bin)))

examples: $(EXAMPLES)

$(EXAMPLES):
	install examples/$@.sh $(PREFIX)/bin/$@

cpu-stream:
	@./umq-recv 9999 -f ./examples/cpu-stream.sh -v

clean:
	rm -f $(BIN)
	$(foreach bin,$(BINS),$(shell rm -f umq-$(bin)))

check: test
test:
	./test.sh

doc:
	@echo "$(BIN).1";
	@curl -# -F page=@$(BIN).1.md -o $(BIN).1 http://mantastic.herokuapp.com
	@for bin in $(BINS); do \
		if ! test -f "umq-$$bin.1"; then continue; fi; \
		echo "umq-$$bin.1"; \
		curl -# -F page=@"umq-$$bin.1.md" -o "umq-$$bin.1" http://mantastic.herokuapp.com; \
	done;

.PHONY: test
