# Makefile for building CMakeTemplate library and test executable

# Build directory
BUILD_DIR := build

.PHONY: all clean debug release help

all: debug release

debug: # Generate debug release using CMake
	@echo "Building Debug version..."
	@cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=Debug
	@cmake --build $(BUILD_DIR) --config Debug
	@echo "Debug version built successfully. Executable: $(DEBUG_EXEC)"

release:  # Generate release release using CMake
	@echo "Building Release version..."
	@cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=Release
	@cmake --build $(BUILD_DIR) --config Release
	@echo "Release version built successfully. Executable: $(RELEASE_EXEC)"

clean:
	@echo "Cleaning..."
	@rm -rf build
	@echo "Done cleaning."

format:
	@echo "Formatting code..."
	@clang-format -i $(wildcard $(HEADERS_DIR)/*.h $(SOURCES_DIR)/*.cpp) main.cpp
	@echo "Done formatting."

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  all       : Build both Debug and Release versions"
	@echo "  debug     : Build Debug version"
	@echo "  release   : Build Release version"
	@echo "  clean     : Clean up build artifacts"
	@echo "  help      : Show this help message"

# If no target is specified, show the help message
.DEFAULT_GOAL := help
