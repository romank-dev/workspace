SUBDIRS = $(wildcard src/*)
			
.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

export G_SRC = $(shell pwd)/src
export G_BIN = $(shell pwd)/bin
export G_OBJ = $(shell pwd)/obj
export G_CXXFLAGS = -g3
export G_LDFLAGS = 
export LDFLAGS_OPENCV = -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_imgcodecs
export INCLUDE_OPENCV = $(shell pkg-config --silence-errors --cflags-only-I opencv4) $(shell pkg-config --silence-errors --cflags-only-I opencv)


$(SUBDIRS):
	@echo "\033[0;97m [ENTER] $@"
	@$(MAKE) -s -C $@  
	@echo "\033[0;97m [EXIT] $@"

.PHONY: all init clean
all: subdirs

-include make_order.txt

clean:
	rm -rf bin obj


