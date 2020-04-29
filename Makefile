CC := g++ # This is the main compiler
SRCDIR := src
BUILDDIR := build
TARGETDIR := lib
LIBBASE := oss-util
LIBNAME := lib$(LIBBASE).a
TARGET := $(TARGETDIR)/$(LIBNAME)
INSTDIRINC := /usr/local/include/$(LIBBASE)
INSTDIRLIB := /usr/local/lib
INSTLIB := $(INSTDIRLIB)/$(LIBNAME)
 
SRCEXT := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
DEPENDS := $(OBJECTS:%.o=%.d)
CFLAGS := -std=c++11 -Wreturn-type -g -pthread -lrt # -Wall

LIBS := \
 /usr/local/lib/libpistache.a


INC := -I ../ \
 -I include \
 -I ./modules/rapidjson/include \
 -I ./modules/freeDiameter/include \
 -I ./modules/c-ares \
 -I /usr/local/include \
 -I ./modules/spdlog/include 

$(TARGET): $(OBJECTS)
	@echo " Linking..."
	@mkdir -p $(TARGETDIR)
	@echo " ar rcs $(TARGET) $(OBJECTS) "; ar rcs $(TARGET) $(OBJECTS) 

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT) Makefile
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -MMD -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -MMD -c -o $@ $<

clean:
	@echo " Cleaning..."; 
	@echo " $(RM) -r $(BUILDDIR) $(TARGETDIR)"; $(RM) -r $(BUILDDIR) $(TARGETDIR)

install: $(TARGET)
	@echo " Installing..."
	@echo "  creating/verifying $(INSTDIRINC)"
	@mkdir -p $(INSTDIRINC)
	@echo "  copying headers to $(INSTDIRINC)"
	@cp -a include/* $(INSTDIRINC)
	@echo "  creating/verifying $(INSTDIRLIB)"
	@mkdir -p $(INSTDIRLIB)
	@echo "  copying $(TARGET) to $(INSTLIB)"
	@cp -a $(TARGET) $(INSTLIB)
	@echo " Installation complete"
	
-include $(DEPENDS)

.PHONY: clean
