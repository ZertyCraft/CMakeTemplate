cmake_minimum_required(VERSION 3.5)
project(
  TestHeader
  VERSION 0.1.0
  DESCRIPTION "CMake template"
  LANGUAGES CXX
)

# Configuration des options de compilation
set(CMAKE_CXX_STANDARD 17)  # Utilisation du standard C++17
set(CMAKE_CXX_STANDARD_REQUIRED ON)  # Le standard C++17 est requis
set(CMAKE_CXX_EXTENSIONS OFF)  # Pas d'extensions du compilateur

# Create options for building static library and executable
option(GENERATE_STATIC_LIBRARY "Generate a static library" ON)
option(GENERATE_EXECUTABLE "Generate an executable" ON)

# Handle warnings as errors option
option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" ON)

if (WARNINGS_AS_ERRORS)
  message(STATUS "Treat compiler warnings as errors")
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Werror)
  elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    add_compile_options(/WX)
  endif ()
endif ()

# Configuration des dossiers de sortie pour les versions Debug et Release
if (GENERATE_STATIC_LIBRARY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/Debug/lib)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release/lib)
endif ()

if (GENERATE_EXECUTABLE)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/Debug/bin)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release/bin)
endif ()

# Configuration des chemins vers les fichiers sources et headers
set(SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Sources)
set(HEADERS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Headers)

# Collecte des fichiers sources
file(GLOB SOURCES ${SOURCES_DIR}/*.cpp)

# Collecte des fichiers headers
file(GLOB HEADERS ${HEADERS_DIR}/*.h)

if (GENERATE_STATIC_LIBRARY)
  # Ajout de la bibliothèque cible
  add_library(CMakeTemplate STATIC ${SOURCES} ${HEADERS})

  # Specify the language for the target library
  set_target_properties(CMakeTemplate PROPERTIES LINKER_LANGUAGE CXX)

  # Définition des chemins d'inclusion pour la bibliothèque
  target_include_directories(CMakeTemplate PUBLIC ${HEADERS_DIR})
endif ()

if (GENERATE_EXECUTABLE)
  # Fichier pour tester la bibliothèque
  add_executable(test_CMakeTemplate main.cpp)

  if (GENERATE_STATIC_LIBRARY)
    # Liaison de la bibliothèque au fichier de test
    target_link_libraries(test_CMakeTemplate PRIVATE CMakeTemplate)
  else()
    # If static library is not generated, link the executable with the source files directly
    target_sources(test_CMakeTemplate PRIVATE ${SOURCES} ${HEADERS})
    target_include_directories(test_CMakeTemplate PRIVATE ${HEADERS_DIR})
  endif ()
endif ()