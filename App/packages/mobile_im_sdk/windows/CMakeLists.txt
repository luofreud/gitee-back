cmake_minimum_required(VERSION 3.14)
project(mobile_im_sdk_library VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})
include(flutter_epilogue)

set(PLUGIN_NAME "mobile_im_sdk_plugin")

add_library(${PLUGIN_NAME} SHARED
  "mobile_im_sdk_plugin.cpp"
)

target_include_directories(${PLUGIN_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter_wrapper_plugin)

set(PLUGIN_BUNDLED_LIBRARIES)
flutter_epilogue(${PLUGIN_NAME})
