CC=g++
EXTRA_FILES=«$1»
OBJECTS=«$2»
CFLAGS=-I $(HOME)/code/ «$3»
LDFLAGS=«$4»
EXE=«$5»

# Suffix setup
.SUFFIXES: .c .cpp .o

.cpp.o:
	$(CC) $(CFLAGS) -c $<

.c.o:
	$(CC) $(CFLAGS) -c $<

# generic makes
all: $(EXE)

$(EXE): $(OBJECTS)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) $(EXTRA_FILES) -o $@

clean:
	rm -f $(OBJECTS) $(EXE)
