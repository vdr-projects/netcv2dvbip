CC=g++
CFLAGS=-O3
LDFLAGS=-s

ARCH= $(shell $(CC) -dumpmachine)
APPLE_DARWIN = $(shell echo $(ARCH) | grep -q 'apple-darwin' && echo "1" || echo "0")
CYGWIN = $(shell echo $(ARCH) | grep -q 'cygwin' && echo "1" || echo "0")
MIPSEL = $(shell echo $(ARCH) | grep -q 'mipsel' && echo "1" || echo "0")

ifeq ($(APPLE_DARWIN), 1)
DEFS:=$(DEFS) -I../common/darwin/include/ -DAPPLE
APPLE=1
CFLAGS:= $(CFLAGS) -fno-common -Wall
else
CFLAGS:= $(CFLAGS) -Wall -Woverloaded-virtual
endif

ifeq ($(MIPSEL),1)
DEFS:=$(DEFS) -DMIPSEL
XML_LIB:=-lxml2
else
XML_INC:=`xml2-config --cflags`
XML_LIB:=`xml2-config --libs`
endif

NETCV_INC:=`pkg-config --cflags libnetceiver`
NETCV_LIB:=`pkg-config --libs libnetceiver`

INCLUDES:=$(INCLUDES) $(XML_INC) $(NETCV_INC)
DEFS:=$(DEFS) -g -DCLIENT
LDADD:=$(LDADD)
LIBS:=$(LIBS) $(XML_LIB) -lpthread $(NETCV_LIB)
LDFLAGS:=$(LDFLAGS) -Wl,--as-needed

netcv2dvbip_OBJECTS=main.o parse.o mclilink.o siparser.o crc32.o clist.o stream.o thread.o misc.o streamer.o igmp.o iface.o

all: netcv2dvbip

netcv2dvbip: $(netcv2dvbip_OBJECTS)
	$(CC) $(LDFLAGS) $(netcv2dvbip_OBJECTS) $(LDADD) $(LIBS) -o $@

.c.o:
	$(CC) $(DEFS) $(INCLUDES)  $(CFLAGS) -c $<

clean:
	$(RM) -f $(DEPFILE) *.o *~ netcv2dvbip netcv2dvbip-static
