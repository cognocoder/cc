
# The application executable image
BIN = cc.app

# The tests executable image
TESTS = cc.tests

# GNU C/C++ compiler flags
warnings = -Wall -Wextra -Werror -Wfatal-errors
pedantic = -pedantic -pedantic-errors

# Language standards 
cstd = -ansi
cppstd = -std=c++20

# Optimization setting
optimization = -O3

# Enables debbuger symbols for GNU GDB
debbuger = -ggdb

  CFLAGS  = $(warnings) $(cstd) $(optimization) $(debbuger)
CPPFLAGS  = $(warnings) $(pedantic) $(cppstd) $(optimization) $(debbuger)

# Directory paths
SOURCES = sources
BUILD = build

# Gather C sources, object and dependency files
CSRC = $(shell find . -type f -wholename './$(SOURCES)/*.c')
OBJ = $(CSRC:%.c=$(BUILD)/%.o)
DEP = $(OBJ:%.o=%.d)

# Gather C++ sources, object and dependency files
CPP = $(shell find . -type f -wholename './$(SOURCES)/*.cpp')
OBJ += $(CPP:%.cpp=$(BUILD)/%.o)
DEP += $(OBJ:%.o=%.d)

# Gather linked libraries
#
# 	  lglfw · GLFW framework
#       lGL · OpenGL
#  	 	 lX11 · X Window System
#  lpthread · POSIX threads
#		lXrandr · X Resize and Rotate
# 			lXi · X input
# 			ldl · Dynamic loader
# lfreetype · FreeType
LIBS = -lglfw -lGL -lX11 -lpthread -lXrandr -lXi -ldl -lfreetype

# Gather library files
CPPFLAGS += -I/usr/include/freetype2

# PHONY targets
.PHONY: clean run tests _cmake cmake

# Copy the executable image from build directory
$(BIN): $(BUILD)/$(BIN)
	@cp $(BUILD)/$(BIN) $(BIN)

# Run the application executable image
run: $(BIN)
	@echo " · enter $(BIN)"
	@./$(BIN)
	@echo

# Run the tests executable image
tests: $(TESTS)

# Link object files into the executable image
$(BUILD)/$(BIN): $(OBJ)
	@mkdir -p $(@D)
	@g++ $(CPPFLAGS) $(LIBS) $^ -o $@ 
	@echo " · build $(BIN)"
	@echo

# Include dependecy files
-include $(DEP)

# Compile C++ sources into object files and generate dependency files
$(BUILD)/%.o: %.cpp
	@mkdir -p $(@D)
	@g++ $(CPPFLAGS) $(LIBS) -MMD -c $< -o $@
	@echo " · build $(*)"

# Compile c sources into object files and generate dependency files
$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	@gcc $(CFLAGS) $(LIBS) -MMD -c $< -o $@
	@echo " · build $(*)"

# Remove derived files
clean:
	@rm -rf $(BUILD) $(BIN) $(TESTS)
	@echo " · clean $(BUILD)"
	@echo " · clean $(BIN)"
	@echo " · clean $(TESTS)"
	@echo

# The tests are built using cmake
$(TESTS): _cmake
	@cd $(BUILD) && $(MAKE)
	@cd ..
	@echo && ./$(TESTS)
	@echo

# Generate build with CMake
_cmake:
	@cmake -S . -B $(BUILD)

# Build with makefile created by CMake 
cmake: _cmake
	@cd $(BUILD) && $(MAKE)
	@cd ..
	@echo && ./$(TESTS) && echo && ./$(BIN)
	@echo

