#  Copyright 2025 Roman Kudinov. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SUBDIRS = $(notdir $(wildcard src/*))
			
.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

export G_SRC = $(shell pwd)/src
export G_BIN = $(shell pwd)/bin
export G_OBJ = $(shell pwd)/obj
export G_CXXFLAGS = -g3
export G_LDFLAGS = 
export LDFLAGS_OPENCV = -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_imgcodecs -lopencv_plot
export INCLUDE_OPENCV = $(shell pkg-config --silence-errors --cflags-only-I opencv4) $(shell pkg-config --silence-errors --cflags-only-I opencv)


$(SUBDIRS):
	@echo "\033[0;97m [ENTER] $@"
	@$(MAKE) -s -C src/$@
	@echo "\033[0;97m [EXIT] $@"

.PHONY: all init clean
all: subdirs

-include make_order.txt

clean:
	rm -rf bin obj


