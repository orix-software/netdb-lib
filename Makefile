SOURCES8=$(wildcard src/*.s)
OBJECTS8=$(SOURCES8:.s=.o)

ifeq ($(CC65_HOME),)
        CC = cl65
        AS = ca65
        LD = ld65
        AR = ar65
else
        CC = $(CC65_HOME)/bin/cl65
        AS = $(CC65_HOME)/bin/ca65
        LD = $(CC65_HOME)/bin/ld65
        AR = $(CC65_HOME)/bin/ar65
endif

all: $(SOURCES8) $(OBJECTS8)

$(OBJECTS8): $(SOURCES8)
	@mkdir target/telestrat/lib/ -p
	@$(AS) -ttelestrat $(@:.o=.s) -o $@ --include-dir src/include
	@echo Generating $@
	@$(AR) r netdb.lib $@
	@mkdir -p build/lib8
	@mkdir -p build/usr/include/
	@mkdir -p build/usr/include/asm
	@cp netdb.lib build/lib8/
	@cp netdb.lib target/telestrat/lib/

clean:
	rm src/*.o
	rm netdb.lib


