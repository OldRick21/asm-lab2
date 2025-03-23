AS = /usr/bin/nasm
LD = /usr/bin/ld

ASFLAGS = -g -f elf64
LDFLAGS = -static
SORT ?= 0

SRCS = src.s
OBJS = $(SRCS:.s=.o)

EXE = bin

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) $(if $(filter 1,$(SORT)),-DSORT_DESCENDING,) $< -o $@
