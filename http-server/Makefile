CC      = gcc
CFLAGS  = -Wall -Wextra -O2 -g
TARGET  = http_server
SRC     = http_server.c

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)

test: $(TARGET)
	./tests/run_all.sh

.PHONY: clean test
