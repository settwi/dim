
prefix=/usr/local

CFLAGS_X86_64 = $(CFLAGS) -target x86_64-apple-macos10.8
CFLAGS_ARM64 = $(CFLAGS) -target arm64-apple-macos11

LDFLAGS += -framework IOKit \
 	-framework ApplicationServices \
 	-framework CoreDisplay \
	-framework Cocoa \
 	-F /System/Library/PrivateFrameworks \
 	-framework DisplayServices \

all:
	$(CC) -v $(LDFLAGS) dim.m -o dim

clean:
	rm dim
